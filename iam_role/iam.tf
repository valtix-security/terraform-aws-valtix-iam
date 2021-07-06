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


resource "aws_iam_role_policy" "valtix_controller_policy_discovery" {
  count = var.discovery_only ? 1 : 0
  name = "${var.prefix}_controller_policy"
  role = aws_iam_role.valtix_controller_role.id

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
			"Action": [
				"ec2:Describe*",
				"acm:Describe*",
				"elasticloadbalancing:Describe*",
				"apigateway:GET",
				"acm:Get*",
				"acm:List*",
				"ec2:Get*"
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
				"${var.s3_bucket_arn}/*"
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
		}
	]
}
EOF
}

resource "aws_iam_role_policy" "valtix_controller_policy" {
  count = var.discovery_only ? 0 : 1
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
        "${var.s3_bucket_arn}/*"
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
      "Resource": "${aws_iam_role.valtix_fw_role[0].arn}"
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

resource "aws_iam_role" "valtix_cloudwatch_event_role" {
  name = "${var.prefix}-inventory-role"

  tags = {
    Name   = "${var.prefix}-inventory-role"
    prefix = var.prefix
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "valtix_cloudwatch_event_policy" {
  name = "${var.prefix}-cloudwatch-event-policy"
  role = aws_iam_role.valtix_cloudwatch_event_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "events:PutEvents",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:events:*:${var.controller_aws_account_number}:event-bus/default"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_role" "valtix_fw_role" {
  count = var.discovery_only ? 0 : 1
  name = "${var.prefix}-firewall-role"
  tags = {
    Name   = "${var.prefix}-firewall-role"
    prefix = var.prefix
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "valtix_fw_policy" {
  count = var.discovery_only ? 0 : 1
  name = "${var.prefix}_fw_policy"
  role = aws_iam_role.valtix_fw_role[0].id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource":"arn:aws:s3:::*/*"
    },
    {
      "Action": [
        "kms:Decrypt"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "secretsmanager:GetSecretValue"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF

  depends_on = [
    aws_iam_role.valtix_fw_role
  ]

}

# for instances to use the role, an instance profile must be created and
# instance profile name used on the instance's iam role
# however on the firewall iam role text box you can provide the role
# name or the arn of either the role or the instance profile
resource "aws_iam_instance_profile" "valtix_fw_role" {
  count = var.discovery_only ? 0 : 1
  name = "${var.prefix}-firewall-role"
  role = aws_iam_role.valtix_fw_role[0].name
  depends_on = [
    aws_iam_role.valtix_fw_role
  ]
}
