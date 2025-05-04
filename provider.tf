terraform {
  backend "s3" {
    bucket       = "bucket-terraform-state-0"
    region       = "us-east-1"
    key          = "terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}
