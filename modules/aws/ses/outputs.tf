output "ses_domain_identity_arn" {
  description = "The ARN of the SES email domain"
  value       = aws_ses_domain_identity.ses_domain.arn
}
