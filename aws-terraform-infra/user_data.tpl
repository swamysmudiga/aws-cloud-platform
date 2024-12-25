#!/bin/bash

# Log to a custom file for validation
LOGFILE="/var/log/userdata.log"

echo "Starting user_data script..." >> $LOGFILE

# Write environment variables to /etc/environment
echo "DB_ENDPOINT=${DB_ENDPOINT}" >> /etc/environment
echo "DB_URL=${DB_URL}" >> /etc/environment
echo "DB_USERNAME=${DB_USERNAME}" >> /etc/environment
echo "DB_PASSWORD=${DB_PASSWORD}" >> /etc/environment
echo "DB_NAME=${DB_NAME}" >> /etc/environment
echo "BANNER=${BANNER}" >> /etc/environment
echo "APPLICATION_NAME=${APPLICATION_NAME}" >> /etc/environment
echo "SHOW_SQL=${SHOW_SQL}" >> /etc/environment
echo "NON_CONTEXTUAL_CREATION=${NON_CONTEXTUAL_CREATION}" >> /etc/environment
echo "HIBERNATE_DIALECT_POSTGRESDIALECT=${HIBERNATE_DIALECT_POSTGRESDIALECT}" >> /etc/environment
echo "HIBERNATE_DDL_AUTO=${HIBERNATE_DDL_AUTO}" >> /etc/environment

# S3 Bucket Configuration
echo "AWS_S3_BUCKET_NAME=${AWS_S3_BUCKET_NAME}" >> /etc/environment
echo "AWS_PROFILE_NAME=${AWS_PROFILE_NAME}" >> /etc/environment
echo "AWS_REGION=${AWS_REGION}" >> /etc/environment

# Define the Image max Size
echo "MAX_FILE_SIZE=${MAX_FILE_SIZE}" >> /etc/environment
echo "MAX_REQUEST_SIZE=${MAX_REQUEST_SIZE}" >> /etc/environment
echo "TOPIC_ARN=${TOPIC_ARN}" >> /etc/environment

# Load the environment variables
 
# Update the systemd service file to load environment variables
cat <<EOT > /etc/systemd/system/springbootapp.service.d/override.conf
[Service]
EnvironmentFile=/etc/environment
EOT
 
# CloudWatch Agent configuration
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
 
# Reload systemd and restart the application
systemctl daemon-reload
systemctl restart springbootapp
