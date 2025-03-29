output "ses_domain_identity_arn" {
  description = "The ARN of the SES email domain"
  value = module.email.ses_domain_identity_arn 
}

output "email_sender_role_arn" {
  description = "The ARN of the IAM role with permission to send email via SES"
  value       = aws_iam_role.email_sender.arn
}

output "aws_region" {
  description = "The AWS region in which resources are provisioned"
  value = data.aws_region.current.name
}
