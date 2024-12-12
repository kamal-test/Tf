variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "aws_session_token" {
  description = "AWS session token (for temporary credentials)"
  type        = string
  sensitive   = true
  default     = null
}

# Configure AWS Provider with declared variables
provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  token      = var.aws_session_token
}

resource "aws_s3_bucket" "bucket-create-from-terrakube" {
  bucket = "bucket-create-from-tofu-controller"

  tags = {
    Name        = "akshat-terrakube"
    Environment = "Dev"
  }
}

provider "aws" {
  region     = "ap-south-1"
}
