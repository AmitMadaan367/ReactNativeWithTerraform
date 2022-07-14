terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      Version = "~>3.27"
    }
  }

  required_version = ">=0.14.9"

}

provider "aws" {
  version = "~>3.0"
  region  = "east-us-1"
}


resource "aws_s3_bucket" "mycodepipeline2" {
  bucket = "my-terraform-first-bucket2"

  tags = {
    Name        = "My terraform bucket"
    Environment = "My-Dev"
  }

}


resource "aws_s3_bucket_versioning" "public_bucket_versioning" {
  bucket = aws_s3_bucket.mycodepipeline2.id 

  versioning_configuration {
    status =   "Enabled"
  }
}

resource "aws_s3_bucket_acl" "mycodepipeline_acl" {
  bucket = aws_s3_bucket.mycodepipeline2.id
  acl    = "private"
}


