terraform {
    backend "s3" {
        bucket = "koronet-state-tf"
        key    = "my-key"
        region = "us-east-2"
    }
}

provider "aws" {
    region = var.aws_region
}

