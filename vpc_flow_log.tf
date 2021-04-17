resource "aws_flow_log" "valtix_flow_log" {
  count                = length(var.log_vpc_id)
  log_destination      = aws_s3_bucket.valtix_s3_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  log_format           = "$${account-id} $${action} $${az-id} $${bytes} $${dstaddr} $${dstport} $${end} $${flow-direction} $${instance-id} $${interface-id} $${log-status} $${packets} $${pkt-dst-aws-service} $${pkt-dstaddr} $${pkt-src-aws-service} $${pkt-srcaddr} $${protocol} $${region} $${srcaddr} $${srcport} $${start} $${sublocation-id} $${sublocation-type} $${subnet-id} $${tcp-flags} $${traffic-path} $${type} $${version} $${vpc-id}"
  vpc_id               = var.log_vpc_id[count.index]
}