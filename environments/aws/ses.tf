data "aws_route53_zone" "mail" {
  name = "shortlistmail.link" 
}

resource "aws_route53_record" "dev_amazonses_verification_record" {
  zone_id = data.aws_route53_zone.mail.id
  name    = "_amazonses.dev.shortlistmail.link"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.dev.verification_token]
}

resource "aws_ses_domain_identity" "dev" {
  domain = "example.com"
}

