resource "aws_security_group" "app_security_group" {
  vpc_id = aws_vpc.csye6225_Swamy_Dev.id
  name   = "application_security_group"

  # Allow SSH access only from the load balancer security group
  ingress {
    description     = "Allow SSH from load balancer"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_security_group.id] # Restrict to LB security group
  }

  # Allow application traffic only from the load balancer security group
  ingress {
    description     = "Allow Application Traffic from load balancer"
    from_port       = var.application_port # Port defined in variable for flexibility
    to_port         = var.application_port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_security_group.id] # Restrict to LB security group
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "App Security Group"
  }
}


# Security group for RDS instance
resource "aws_security_group" "db_security_group" {
  vpc_id = aws_vpc.csye6225_Swamy_Dev.id
  name   = "database_security_group"

  ingress {
    description     = "Allow PostgresSQL access from application security group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_security_group.id] # Only allow from app SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB Security Group"
  }
}

# Security Group for Load Balancer
resource "aws_security_group" "lb_security_group" {
  vpc_id = aws_vpc.csye6225_Swamy_Dev.id
  name   = "load_balancer_security_group"

  # Allow inbound HTTP traffic on port 80
  ingress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow inbound HTTPS traffic on port 443
  ingress {
    description      = "Allow HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Load Balancer Security Group"
  }
}
