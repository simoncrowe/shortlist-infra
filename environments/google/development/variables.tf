
variable "rm_results_url" {
  description = "The RM results URL to run the ingester as a cron job with"
  type        = string
  default     = ""
}

variable "base_listing_url" {
  description = "The base URL onto which to append listing IDs"
  type        = string
  default     = ""
}

variable "rm_source_email" {
  description = "The email from which to send selected RM profiles"
  type        = string
}

variable "rm_destination_email" {
  description = "The email to send selected RM profiles to"
  type        = string
  default     = ""
}

variable "rm_emailer_aws_role_arn" {
  description = "The ARN of the AWS IAM role with permission to send email via SES"
  type        = string
  default     = ""
}

variable "rm_emailer_aws_ses_identity_arn" {
  description = "The ARN of the AWS SES email domain"
  type        = string
  default     = ""
}

variable "rm_emailer_aws_region" {
  description = "The AWS region in which the SES domain is deployed"
  type        = string
  default     = ""
}

variable "assessor_llm_system_prompt" {
  description = "The system prompt telling LLMs how to assess profiles"
  type        = string
}

variable "assessor_llm_positive_response_regex" {
  description = "The regular expression used to match positive responses from LLMs"
  type        = string
  default     = "[Yy][Ee][Ss]"
}

variable "assessor_llm_access_token" {
  description = "Token granting access to the assessor LLM model"
  type        = string
}
