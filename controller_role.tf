
# create a role that will be used by valtix controller with permissions
resource "aws_iam_role" "valtix_controller_role" {
  name = "${var.prefix}controllerrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${var.controller_aws_account_number}:root"
        ]
      },
      "Effect": "Allow",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${var.ExternalId}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "valtix_controller_policy" {
  name = "${var.prefix}_controller_policy"
  role = aws_iam_role.valtix_controller_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": [
          "apigateway:GET",
          "ec2:*",
          "elasticloadbalancing:*",
          "route53:ListHostedZones",
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:ListHostedZonesByName",
          "servicequotas:GetServiceQuota"
        ],
        "Effect": "Allow",
        "Resource": "*"
    },
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.valtix_s3_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "iam:GetRole",
        "iam:ListRolePolicies",
        "iam:GetRolePolicy"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_iam_role.valtix_controller_role.arn}"
      ]
    },
    {
      "Action": [
        "iam:GetRole",
        "iam:ListRolePolicies",
        "iam:GetRolePolicy",
        "iam:PassRole"
      ],
      "Effect": "Allow",
      "Resource": "${aws_iam_role.valtix_fw_role.arn}"
    },
    {
      "Action": "iam:CreateServiceLinkedRole",
      "Effect": "Allow",
      "Resource": "arn:aws:iam::*:role/aws-service-role/*"
    }
  ]
}

EOF
}