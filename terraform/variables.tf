# AWS variables
variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "sa-east-1"
}

variable "aws_az_names" {
  type        = list(string)
  description = "Name of zones to be available"
  default     = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
}

variable "domain" {
  type        = string
  description = "The domain to be used for Cloudfront Distribution"
}

variable "certificate_arn" {
  type        = string
  description = "The ARN of the certificate to be used for Cloudfront Distribution"
}

variable "api_stage" {
  type        = string
  description = "The stage for deployment"
  default     = "development"
}

variable "api_secret_token" {
  type        = string
  description = "The API secret token"
}
