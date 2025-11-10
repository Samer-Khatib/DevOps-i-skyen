variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-1"
}

variable "bucket_name" {
  type        = string
  description = "e.g. kandidat-samer-data (lowercase, digits, hyphens)"
}

variable "transition_days" {
  type        = number
  default     = 30
  validation {
    condition     = var.transition_days >= 30
    error_message = "transition_days must be >= 30 for STANDARD_IA."
  }
}

variable "expire_days" {
  type        = number
  default     = 60
  validation {
    condition     = var.expire_days > var.transition_days
    error_message = "expire_days must be greater than transition_days."
  }
}
