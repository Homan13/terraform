# Define AWS as our provider
provider "aws" {
    region = "us-east-1"
}

# Terraform remote state
terraform {
    backend "s3" {
        bucket    = "s3-homan-terraform-state"
        key       = "s3-homan-terraform-state/terraform.tfstate"
        region    = "us-east-1"
    }
}