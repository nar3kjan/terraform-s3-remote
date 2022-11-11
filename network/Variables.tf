variable "env" {
    default = "dev"
}

variable "cidr_blocks_public" {
  default = [
  "10.10.1.0/24", 
  "10.10.2.0/24"
  ]
  }

variable "cidr_blocks_private" {
  default = [
  "10.10.10.0/24", 
  "10.10.20.0/24"
  ]
  }

variable "aws_region" {
  default = "us-east-1"
}


variable "common_tags" {
  default = {
    Name = "My Network"
    Owner = "Narek Arakelyan"
    Environment = "Development"
  }
}