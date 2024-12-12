# Configure the AWS Provider
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

# Configure AWS Provider with declared variables
provider "aws" {
  region     = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "bucket-create-from-terrakube" {
  bucket = "bucket-create-from-tofu-controller"

  tags = {
    Name        = "akshat-terrakube"
    Environment = "Dev"
  }
}
