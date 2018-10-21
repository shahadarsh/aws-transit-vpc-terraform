module "transit-vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "1.46.0"

  name = "transit-vpc"
  cidr = "100.64.127.224/27"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["100.64.127.224/28", "100.64.127.240/28"]

  tags = {
    Terraform = "true"
  }
}
