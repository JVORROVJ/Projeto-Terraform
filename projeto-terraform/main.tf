terraform {
  required_version = ">=1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.74.0"
    }
  }
  backend "s3" {
    bucket = "terraform-jvor"
    key    = "path/to/my/key"
    region = "us-east-1"

  }
}

provider "aws" {
  region = "${var.region}"
  default_tags {
    tags = {
      dono    = "hehefatcat"
    }
  }
}