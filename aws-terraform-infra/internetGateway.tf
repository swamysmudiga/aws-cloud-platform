resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.csye6225_Swamy_Dev.id

  tags = {
    Name = "IG Cloud Project"
  }
}
