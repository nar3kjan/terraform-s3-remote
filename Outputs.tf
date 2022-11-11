
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

output "certificate_id" {
  value = aws_acm_certificate.cert.id
}

output "elb-id" {
  value = aws_lb.web.id
}

output "elb_zone_id" {
  value = aws_lb.web.zone_id
}

output "elb_dns_name" {
  value = aws_lb.web.dns_name
}