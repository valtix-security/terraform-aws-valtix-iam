resource "aws_route53_resolver_query_log_config" "valtix_route53_query_logging" {
  name            = "${var.prefix}-route53-logging"
  destination_arn = aws_s3_bucket.valtix_s3_bucket.arn
}

resource "aws_route53_resolver_query_log_config_association" "valtix_route53_query_logging_vpc_assoc" {
  count                        = length(var.route53log_vpc_ids)
  resolver_query_log_config_id = aws_route53_resolver_query_log_config.valtix_route53_query_logging.id
  resource_id                  = var.route53log_vpc_ids[count.index]
}