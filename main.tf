provider "aws" {
  region = var.region
}

module "iam" {
  source = "./iam_role"
  controller_aws_account_number = var.controller_aws_account_number
  prefix = var.prefix
  ExternalId = var.ExternalId
  s3_bucket_arn = aws_s3_bucket.valtix_s3_bucket.arn
  discovery_only = var.discovery_only
}


data "aws_caller_identity" "current" {}
data "aws_region" "current" {}



resource "aws_s3_bucket" "valtix_s3_bucket" {
  bucket        = var.s3_bucket
  force_destroy = true
  acl           = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "valtix_s3_bucket_policy" {
  bucket = aws_s3_bucket.valtix_s3_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Action = "s3:GetBucketAcl"
        Effect = "Allow"
        Resource = aws_s3_bucket.valtix_s3_bucket.arn
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      },
      {
        Action = "s3:PutObject"
        Effect = "Allow"
        Resource = "${aws_s3_bucket.valtix_s3_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
      },
      {
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action = "s3:GetBucketAcl"
        Effect = "Allow"
        Resource = aws_s3_bucket.valtix_s3_bucket.arn
      },
      {
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action = "s3:PutObject"
        Effect = "Allow"
        Resource = "${aws_s3_bucket.valtix_s3_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" : "bucket-owner-full-control"
          }
        }
       }
    ]
  })
}


resource "aws_s3_bucket_notification" "valtix_s3_bucket_notification" {
  bucket = aws_s3_bucket.valtix_s3_bucket.id

  queue {
    queue_arn = "arn:aws:sqs:${data.aws_region.current.name}:${var.controller_aws_account_number}:inventory_logs_queue_${var.deployment_name}_${data.aws_region.current.name}"
    events    = ["s3:ObjectCreated:*"]
  }
  depends_on = [
     aws_s3_bucket_policy.valtix_s3_bucket_policy
  ]
}

resource "aws_cloudtrail" "valtix_cloudtrail" {
  name                          = "${var.prefix}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.valtix_s3_bucket.id
  enable_log_file_validation    = true
  is_multi_region_trail         = true
  include_global_service_events = true
  enable_logging                = true
  depends_on = [
    aws_s3_bucket_policy.valtix_s3_bucket_policy, 
  ]

  tags = {
    Name   = "${var.prefix}-cloudtrail"
    prefix = var.prefix
  }

}

resource "aws_cloudwatch_event_rule" "cloudwatch_rule" {
  name          = "${var.prefix}-inventory-rule"
  event_pattern = <<EOF
{
    "source": [
        "aws.ec2",
        "aws.elasticloadbalancing",
        "aws.apigateway"
    ],
    "detail-type": [
        "AWS API Call via CloudTrail",
        "EC2 Instance State-change Notification"
    ]
}
EOF
}

resource "aws_cloudwatch_event_target" "controller_target" {
  rule     = aws_cloudwatch_event_rule.cloudwatch_rule.name
  arn      = "arn:aws:events:${var.region}:${var.controller_aws_account_number}:event-bus/default"
  role_arn = module.iam.valtix_cloudwatch_event_role.arn
}

resource "aws_route53_resolver_query_log_config" "valtix_route53_query_logging" {
  name            = "${var.prefix}-route53-logging"
  destination_arn = aws_s3_bucket.valtix_s3_bucket.arn
  depends_on = [aws_s3_bucket_policy.valtix_s3_bucket_policy]
}

