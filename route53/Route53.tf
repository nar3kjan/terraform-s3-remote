provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

terraform {
  backend "s3" {
    bucket = "nar3kjan-project-terraform-remote-state"
    key = "dev/route53/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "servers" {
  backend = "s3"
  config = {
    bucket = "nar3kjan-project-terraform-remote-state"
    key = "dev/servers/terraform.tfstate"
    region = "us-east-1"
  }
}



data "aws_route53_zone" "my_zone" {
  name         = "nar3kjan.link"
  private_zone = false
}
#-----------------------------------------------------------------------------------------------
resource "aws_acm_certificate" "cert" {
  domain_name       = "nar3kjan.link"
  subject_alternative_names = ["www.nar3kjan.link"]
  validation_method = "DNS"
}



resource "aws_route53_record" "my_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.my_zone.zone_id
}



resource "aws_acm_certificate_validation" "validation_www" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.my_record : record.fqdn]
}



resource "aws_route53_record" "www_elb" {
  zone_id = data.aws_route53_zone.my_zone.id
  name    = "www"
  type    = "A"

  alias {
    name                   = data.terraform_remote_state.servers.outputs.elb_dns_name
    zone_id                = data.terraform_remote_state.servers.outputs.elb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "elb" {
  zone_id = data.aws_route53_zone.my_zone.id
  name    = "nar3kjan.link"
  type    = "A"

  alias {
    name                   = data.terraform_remote_state.servers.outputs.elb_dns_name
    zone_id                = data.terraform_remote_state.servers.outputs.elb_zone_id
    evaluate_target_health = true
  }
}

