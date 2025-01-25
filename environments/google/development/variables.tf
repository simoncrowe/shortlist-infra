
variable "rm_results_url" {
  description = "The RM results URL to run the ingester as a cron job with"
  type        = string
  default     = ""
}

variable "rm_destination_email" {
  description = "The email to send selected RM profiles to" 
  type        = string
  default     = ""
}

variable "rm_emailer_aws_role_arn" {
  description = "The ARN of the AWS IAM role with permission to send email via SES"
  type = string
  default = ""  
}

variable "rm_emailer_aws_ses_identity_arn" {
  description = "The ARN of the AWS SES email domain"
  type = string
  default = ""
}

variable "rm_emailer_aws_region" {
  description = "The AWS region in which the SES domain is deployed" 
  type = string
  default = ""
}
