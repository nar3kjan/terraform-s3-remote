data "aws_availability_zones" "available" {}

#======================================================

resource "aws_vpc" "main"  {
    cidr_block = "10.10.0.0/16"
    tags = var.common_tags
}


resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = var.common_tags
}


resource "aws_subnet" "public_subnet" {
  count = length(var.cidr_blocks_public)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.cidr_blocks_public, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet - ${count.index +1}"
  }
}

resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = var.common_tags
}

resource "aws_route_table_association" "public" {
  count = length(var.cidr_blocks_public)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = element(aws_route_table.public_subnet[*].id, count.index)
}

#========================================================================================
/*
resource "aws_subnet" "private_subnet" {
  count = length(var.cidr_blocks_private)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.cidr_blocks_private, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
   tags = {
    Name = "Private Subnet - ${count.index +1}"
  }
}


resource "aws_eip" "nat_eip" {
  vpc = true
  tags = var.common_tags
}


resource "aws_nat_gateway" "nat" {
  subnet_id = aws_subnet.private_subnet[0].id
  allocation_id = aws_eip.nat_eip.id
  tags = var.common_tags
}

resource "aws_route_table" "private_subnet" {
  vpc_id = aws_vpc.main.id
  count = length(var.cidr_blocks_private)
  route {
    cidr_block = element(var.cidr_blocks_private, count.index)
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = var.common_tags
}

resource "aws_route_table_association" "private" {
  count = length(var.cidr_blocks_private)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = element(aws_route_table.private_subnet[*].id, count.index)
}
*/
