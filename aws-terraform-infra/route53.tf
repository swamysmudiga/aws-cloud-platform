resource "aws_route53_record" "app_a_record" {
  zone_id = var.route53_zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = var.record_type

  alias {
    name                   = aws_lb.app_lb.dns_name # ALB DNS name
    zone_id                = aws_lb.app_lb.zone_id  # ALB hosted zone ID
    evaluate_target_health = true
  }
}
