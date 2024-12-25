# Database password secret
resource "aws_secretsmanager_secret" "db_password_secret" {
  name                    = "db-password"
  recovery_window_in_days = 0
  kms_key_id              = aws_kms_key.secrets_key.id
}

resource "aws_secretsmanager_secret_version" "db_password_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_password_secret.id
  secret_string = jsonencode({ "password" = random_password.db_password.result })
}

# Email credentials secret
resource "aws_secretsmanager_secret" "email_credentials_secret" {
  name                    = var.email_secret_name_mailgun
  recovery_window_in_days = 0
  kms_key_id              = aws_kms_key.secrets_key.id
}

resource "aws_secretsmanager_secret_version" "email_credentials_secret_version" {
  secret_id = aws_secretsmanager_secret.email_credentials_secret.id
  secret_string = jsonencode({
    "MAILGUN_API_URL"   = var.mailgun_api_url
    "MAILGUN_API_KEY"   = var.mailgun_api_key
    "FROM_EMAIL"        = var.from_email
    "VERIFICATION_LINK" = var.verification_link
  })
}

# Generate random password
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#%&*()-_=+<>?"
}
