# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.csye6225_Swamy_Dev.id
  tags = {
    Name = "public-route-table"
  }
}
# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create route to the internet
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.csye6225_Swamy_Dev.id
  tags = {
    Name = "private-route-table"
  }
}

# Associate private route table with private subnets
resource "aws_route_table_association" "private_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}
