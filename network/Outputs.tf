
/*
output "aws_private_subnet1_id" {
  value = aws_subnet.private_subnet[0].id
}

output "aws_private_subnet2_id" {
  value = aws_subnet.private_subnet[1].id
}
*/

output "aws_public_subnet1_id" {
  value = aws_subnet.public_subnet[0].id
}

output "aws_public_subnet2_id" {
  value = aws_subnet.public_subnet[1].id
}


output "vpc_id" {
    value = aws_vpc.main.id
}

output "aws_vpc_cidrs" {
    value = aws_vpc.main.cidr_block
} 

