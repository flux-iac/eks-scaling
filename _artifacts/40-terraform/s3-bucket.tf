terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "region" { }

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "my-tfc-private-bucket" {

  bucket = "my-tfc-private-bucket"
  acl    = "private"

  tags = {
    Name        = "My private bucket"
    Environment = "Dev"
  }

}
