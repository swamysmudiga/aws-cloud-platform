resource "aws_vpc" "csye6225_Swamy_Dev" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "VPC Cloud Project"
  }
}
