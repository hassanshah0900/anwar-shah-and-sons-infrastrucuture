resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  region     = var.region
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

variable "public_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.azs[count.index]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "zonal" {
  availability_mode = "zonal"
  subnet_id         = aws_subnet.public[0].id
  allocation_id     = aws_eip.nat.id
}

variable "private_subnet_cidr_blocks" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.azs[count.index]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.zonal.id
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}
