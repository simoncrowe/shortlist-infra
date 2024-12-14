data "aws_route53_zone" "domain" {
  name = var.domain
}

module "email" {
  source = "../../../modules/aws/ses/"

  mail_domain = "dev.${var.domain}"
  zone_id     = data.aws_route53_zone.domain.id
}


