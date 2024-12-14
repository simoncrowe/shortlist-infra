terraform {
  backend "s3" {
    bucket = "terraform-backend-9b63dac565cd"
    key    = "shortlist/dev"
    region = "eu-north-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
