resource "aws_launch_template" "csye6225_launch_template" {
  depends_on    = [aws_secretsmanager_secret_version.db_password_secret_version] # Ensure secret is created first
  name          = var.launch_template_name
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.app_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_security_group.id]
  }

  user_data = base64encode(templatefile("${path.module}/user_data.tpl", {
    DB_ENDPOINT                       = aws_db_instance.csye6225_rds.endpoint
    DB_URL                            = "${var.jdbc_prefix}://${aws_db_instance.csye6225_rds.endpoint}/${var.db_name}"
    DB_USERNAME                       = var.db_user
    DB_PASSWORD                       = jsondecode(aws_secretsmanager_secret_version.db_password_secret_version.secret_string).password
    DB_NAME                           = var.db_name
    BANNER                            = var.banner_mode
    APPLICATION_NAME                  = var.application_name
    SHOW_SQL                          = var.show_sql
    NON_CONTEXTUAL_CREATION           = var.non_contextual_creation
    HIBERNATE_DIALECT_POSTGRESDIALECT = var.hibernate_dialect
    HIBERNATE_DDL_AUTO                = var.hibernate_ddl_auto
    AWS_S3_BUCKET_NAME                = aws_s3_bucket.example_bucket.id
    AWS_PROFILE_NAME                  = var.aws_profile_name
    AWS_REGION                        = var.region
    MAX_FILE_SIZE                     = var.max_file_size
    MAX_REQUEST_SIZE                  = var.max_request_size
    TOPIC_ARN                         = aws_sns_topic.user_verification_topic.arn
  }))

  # Block device mapping with KMS encryption
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
      volume_type = "gp2"
      encrypted   = true
      kms_key_id  = aws_kms_key.ebs.arn
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name             = var.instance_name
      Environment      = var.environment
      AutoScalingGroup = var.asg_name
    }
  }
}

resource "aws_autoscaling_group" "csye6225_asg" {
  name             = var.autoscaling_group_name
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size
  launch_template {
    id      = aws_launch_template.csye6225_launch_template.id
    version = "$Latest"
  }

  vpc_zone_identifier = aws_subnet.public_subnets[*].id
  health_check_type   = var.health_check_type
  target_group_arns   = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
  tag {
    key                 = "AutoScalingGroup"
    value               = var.asg_name
    propagate_at_launch = true
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.asg_name}_high_cpu_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.cpu_high_threshold
  alarm_description   = "Alarm when CPU exceeds ${var.cpu_high_threshold}%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.csye6225_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_up_policy.arn]
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "${var.asg_name}_scale_up"
  scaling_adjustment     = var.scale_up_adjustment
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.csye6225_asg.name
  cooldown               = var.cooldown
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.asg_name}_low_cpu_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.cpu_low_threshold
  alarm_description   = "Alarm when CPU is below ${var.cpu_low_threshold}%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.csye6225_asg.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_down_policy.arn]
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "${var.asg_name}_scale_down"
  scaling_adjustment     = var.scale_down_adjustment
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.csye6225_asg.name
  cooldown               = var.cooldown
}
