resource "aws_route53_resolver_query_log_config" "valtix_route53_query_logging" {
  name            = "${var.prefix}-route53-logging"
  destination_arn = aws_s3_bucket.valtix_s3_bucket.arn
}