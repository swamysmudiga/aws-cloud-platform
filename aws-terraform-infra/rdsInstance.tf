# PostgreSQL Parameter Group for custom DB configurations
# Defining the Postgres Version
resource "aws_db_parameter_group" "rds_pg" {
  name   = var.db_parameter_group_name
  family = var.db_parameter_group_family

  #parameter {
  #name  = "max_connections"
  #value = "150"
  #}

  tags = {
    Name = "csye6225 PostgreSQL Parameter Group"
  }
}

# Create RDS instance
resource "aws_db_instance" "csye6225_rds" {
  identifier             = var.db_identifier
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.db_user
  password               = jsondecode(aws_secretsmanager_secret_version.db_password_secret_version.secret_string).password
  parameter_group_name   = aws_db_parameter_group.rds_pg.name
  vpc_security_group_ids = [aws_security_group.db_security_group.id] # Attach DB security group
  skip_final_snapshot    = var.skip_final_snapshot
  publicly_accessible    = var.publicly_accessible # No public access
  multi_az               = var.multi_az            # Disable Multi-AZ
  availability_zone      = element(data.aws_availability_zones.available.names, 0)
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name # Use private subnet group

  kms_key_id        = aws_kms_key.rds_key.arn
  storage_encrypted = true # Enable storage encryption

  tags = {
    Name = "csye6225 RDS Instance"
  }
}

# Create DB Subnet Group for RDS instances in private subnets
# what id * in Subnet_ids // Ans --> it takes all the private subnets
resource "aws_db_subnet_group" "db_subnet" {
  name       = "csye6225-db-subnet-group"
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "csye6225 DB Subnet Group"
  }
}
