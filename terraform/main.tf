#terraform {
#  backend "s3" {
#    key = "aws-transit-vpc-terraform/terraform.tfstate"
#    region = "us-east-1"
#  }
#}

provider "aws" {
  region = "${var.region}"
}
