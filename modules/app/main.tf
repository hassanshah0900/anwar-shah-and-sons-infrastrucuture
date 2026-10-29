locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_iam_policy_document" "app_trust" {
  statement {
    sid     = "AllowEC2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "db_connect" {
  statement {
    sid       = "AllowAuroraDatabaseConnect"
    effect    = "Allow"
    actions   = ["rds-db:connect"]
    resources = ["arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:db-user:${var.db_cluster_resource_id}/${var.db_user}"]
  }
}

resource "aws_iam_role" "app" {
  name               = "${local.name_prefix}-app-role"
  assume_role_policy = data.aws_iam_policy_document.app_trust.json
}

resource "aws_iam_role_policy" "app_db_access" {
  name   = "${local.name_prefix}-app-db-access"
  role   = aws_iam_role.app.id
  policy = data.aws_iam_policy_document.db_connect.json
}

resource "aws_iam_instance_profile" "app" {
  name = "${local.name_prefix}-app-instance-profile"
  role = aws_iam_role.app.name
}

resource "aws_security_group" "alb" {
  name   = "${local.name_prefix}-alb-sg"
  vpc_id = var.vpc_id

  ingress = [
    {
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
    }
  ]

  egress = [
    {
      security_groups = [aws_security_group.app.id]
      protocol        = "tcp"
      from_port       = 80
      to_port         = 80
    }
  ]
}

resource "aws_security_group" "app" {
  name   = "${local.name_prefix}-app-sg"
  vpc_id = var.vpc_id

  ingress = [{
    security_groups = [aws_security_group.alb.id]
    from_port       = 80
    to_port         = 80
  }]

  egress = [{
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }]
}

resource "aws_launch_template" "app" {
  instance_type = var.instance_type
  image_id      = data.aws_ami.ubuntu.id
  key_name      = "linux"

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.app.id]
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.app.arn
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_type           = "gp3"
      volume_size           = 16
      encrypted             = true
      delete_on_termination = true
    }
  }
}

resource "aws_lb_target_group" "app" {
  name_prefix = "${local.name_prefix}-tg"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = var.vpc_id

  deregistration_delay = 30

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "app" {
  name               = "${local.name_prefix}-app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb.id]

  enable_deletion_protection = true

  drop_invalid_header_fields = true
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app.arn
  }
}

resource "aws_autoscaling_group" "app" {
  name_prefix = "${local.name_prefix}-asg"

  launch_template {
    id      = aws_launch_template.app.id
    version = aws_launch_template.app.latest_version
  }

  vpc_zone_identifier = var.private_subnet_ids

  availability_zone_distribution {
    capacity_distribution_strategy = "balanced-best-effort"
  }

  target_group_arns         = [aws_alb_target_group.app.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  desired_capacity = 1
  min_size         = 1
  max_size         = 5

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 100
      max_healthy_percentage = 150
      instance_warmup        = 300
      auto_rollback          = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
