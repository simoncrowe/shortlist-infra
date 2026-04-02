locals {
  from_domain = "mail.${var.mail_domain}"
}

resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.mail_domain
}

resource "aws_ses_domain_mail_from" "from_domain" {
  domain           = var.mail_domain 
  mail_from_domain = local.from_domain 
}

resource "aws_route53_record" "mail_from_mx" {
  zone_id = var.zone_id
  name    = local.from_domain 
  type    = "MX"
  ttl     = "3600"
  records = ["10 feedback-smtp.${data.aws_region.current.name}.amazonses.com"]
}

resource "aws_route53_record" "amazonses_spf_record" {
  zone_id = var.zone_id
  name    = local.from_domain 
  type    = "TXT"
  ttl     = "3600"
  records = ["v=spf1 include:amazonses.com ~all"]
}
resource "aws_route53_record" "amazonses_verification_record" {
  zone_id = var.zone_id
  name    = "_amazonses.${var.mail_domain}"
  type    = "TXT"
  ttl     = "1800"
  records = [join("", aws_ses_domain_identity.ses_domain[*].verification_token)]
}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  domain = join("", aws_ses_domain_identity.ses_domain[*].domain)
}

resource "aws_route53_record" "amazonses_dkim_record" {
  count = 3

  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens, count.index)}._domainkey.${var.mail_domain}"
  type    = "CNAME"
  ttl     = "1800"
  records = ["${element(aws_ses_domain_dkim.ses_domain_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "dmark_record" {
  zone_id = var.zone_id
  name = "_dmarc.${var.mail_domain}"
  type = "TXT"
  ttl  = "3600"
  records = ["v=DMARC1; p=none;"]
}
