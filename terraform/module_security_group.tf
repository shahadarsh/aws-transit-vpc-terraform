module "csr_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "csr_sg"
  description = "CSR Security Group"
  vpc_id      = "${module.transit-vpc.vpc_id}"

  egress_with_cidr_blocks = [
    {
      from_port   = 0 
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
