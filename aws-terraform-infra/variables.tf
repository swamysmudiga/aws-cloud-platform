variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  #default     = "us-east-1" # Optional default value
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1d", "us-east-1e", "us-east-1f"]
}

variable "ami_id" {
  description = "The ID of the custom AMI to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro" # Default instance type if none is provided
}

variable "application_port" {
  description = "Port on which the application runs"
  type        = number
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 25 # Default size is 25GB if none is provided
}

variable "jdbc_prefix" {
  description = "The JDBC prefix for the database connection"
  type        = string
  default     = "jdbc:postgresql" # Default JDBC prefix
}

variable "db_user" {
  default = "postgres"
}

variable "db_pass" {
  default = "Northeastern2024"
}

variable "db_name" {
  default = "webapp"
}
variable "db_port" {
  type    = number
  default = 5432
}

variable "db_identifier" {
  description = "The identifier for the RDS instance"
  type        = string
  default     = "csye6225" # Default value, can be overridden
}

variable "db_engine" {
  description = "The database engine for the RDS instance"
  type        = string
  default     = "postgres" # Default database engine
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "16.3" # Default version
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro" # Default instance type
}

variable "allocated_storage" {
  description = "The allocated storage in GB for the RDS instance"
  type        = number
  default     = 20 # Default storage
}
variable "skip_final_snapshot" {
  description = "Skip final snapshot when deleting the RDS instance"
  type        = bool
  default     = true # Default value, can be overridden
}

variable "publicly_accessible" {
  description = "Allow public access to the RDS instance"
  type        = bool
  default     = false # Default value, can be overridden
}

variable "multi_az" {
  description = "Enable Multi-AZ for the RDS instance"
  type        = bool
  default     = false # Default value, can be overridden
}

variable "db_parameter_group_name" {
  description = "The name of the RDS parameter group"
  type        = string
  default     = "csye6225-db-parameter-group" # Default value, can be overridden
}

variable "db_parameter_group_family" {
  description = "The family of the RDS parameter group"
  type        = string
  default     = "postgres16" # Default value, can be overridden
}

# Spring Boot-specific environment variables
variable "banner_mode" {
  default = "off"
}

variable "application_name" {
  default = "webapp"
}

variable "show_sql" {
  default = "true"
}

variable "non_contextual_creation" {
  default = "true"
}

variable "hibernate_dialect" {
  default = "org.hibernate.dialect.PostgreSQLDialect"
}

variable "hibernate_ddl_auto" {
  default = "update"
}

variable "volume_type" {
  default = "gp2"
}
variable "delete_on_termination" {
  default = "true"
}

# Define variables if not already defined
variable "domain_name" {
  description = "The domain name for the application"
  type        = string
}

variable "subdomain" {
  description = "The subdomain to be created"
  type        = string
  default     = "dev"
}

variable "route53_zone_id" {
  description = "The Route 53 hosted zone ID"
  type        = string
}

variable "record_type" {
  type    = string
  default = "A"
}

variable "record_ttl" {
  type    = number
  default = 60
}

variable "s3_bucket_server_side_encryption_algorithm_name" {
  type    = string
  default = "AES256"
}

# AWS Profile Name
variable "aws_profile_name" {
  description = "The AWS profile to use, defaulting to 'dev'"
  type        = string
  default     = "dev"
}

# Maximum File Size for Multipart Uploads
variable "max_file_size" {
  description = "The maximum file size for file uploads, defaulting to 1MB"
  type        = string
  default     = "1MB"
}

# Maximum Request Size for Multipart Requests
variable "max_request_size" {
  description = "The maximum request size for multipart requests, defaulting to 1MB"
  type        = string
  default     = "1MB"
}

variable "key_name" {
  description = "The name of the SSH key pair to use for SSH access to the instances"
  type        = string
  default     = "ec2"
}


variable "desired_capacity" {
  default = 3
}
variable "max_size" {
  default = 5
}
variable "min_size" {
  default = 3
}
variable "health_check_type" {
  default = "ELB"
}
variable "cpu_high_threshold" {
  default = 12
}
variable "cpu_low_threshold" {
  default = 8
}
variable "scale_up_adjustment" {
  default = 1
}
variable "scale_down_adjustment" {
  default = -1
}
variable "cooldown" {
  default = 60
}
variable "environment" {
  default = "Production"
}
variable "asg_name" {
  default = "CSYE6225-ASG"
}
variable "instance_name" {
  default = "CSYE6225-EC2"
}

variable "mailgun_api_url" {
  type = string
}
variable "mailgun_api_key" {
  type = string
}
variable "from_email" {
  type = string
}
variable "verification_link" {
  type = string
}

#variable "domain_url" {
#type = string
#}

variable "launch_template_name" {
  description = "This launch template name is passed in the packer file using github secrets"
  type        = string
  default     = "csye6225-launch-template"
}

variable "autoscaling_group_name" {
  description = "This auto scaling group name is passed in the packer file using github secrets"
  type        = string
  default     = "csye6225-autoscaling-group"
}

variable "kms_key_rotation_period" {
  description = "Rotation period for KMS key in days"
  default     = 90
}

variable "deletion_window_in_days" {
  description = "Deletion period for KMS key in days"
  default     = 30
}

variable "email_secret_name_mailgun" {
  type    = string
  default = "email-credentials"
}

variable "lambda_function_timeout" {
  description = "lambda function timeout in seconds"
  default     = 30
}

variable "lambda_function_memory_size" {
  description = "lambda function memory size"
  default     = 400
}
