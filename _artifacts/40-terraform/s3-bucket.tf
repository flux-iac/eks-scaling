terraform {
  required_version = ">= 1.1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "weaveworks"

    workspaces {
      name = "dev"
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
    NewTag      = "New tag"
  }

}
