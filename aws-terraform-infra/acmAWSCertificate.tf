data "aws_acm_certificate" "ssl_certificate" {
  domain      = "${var.subdomain}.${var.domain_name}"
  most_recent = true
  statuses    = ["ISSUED"]
}
