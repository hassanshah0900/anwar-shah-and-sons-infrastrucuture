output "vpc_id" {
  type  = string
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  type  = list(string)
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  type  = list(string)
  value = aws_subnet.private[*].id
}
