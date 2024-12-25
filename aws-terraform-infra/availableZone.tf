# Fetching availability zones dynamically
data "aws_availability_zones" "available" {
  state = "available"
}
