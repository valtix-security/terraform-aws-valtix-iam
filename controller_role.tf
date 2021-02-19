
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
        "Effect": "Allow",
        "Action": [
            "ec2:Describe*",
            "ec2:Get*"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:RunInstances",
            "ec2:RequestSpotInstances",
            "ec2:StopInstances",
            "ec2:StartInstances",
            "ec2:ModifyInstanceAttribute",
            "ec2:TerminateInstances",
            "ec2:CancelSpotInstanceRequests",
            "ec2:StopInstances",
            "ec2:AttachNetworkInterface",
            "ec2:CreateNetworkInterface",
            "ec2:ModifyNetworkInterfaceAttribute",
            "ec2:DeleteNetworkInterface",
            "ec2:ReleaseAddress",
            "ec2:DisassociateAddress",
            "ec2:AllocateAddress",
            "ec2:AssociateAddress",
            "ec2:DisassociateIamInstanceProfile",
            "ec2:AssociateIamInstanceProfile",
            "ec2:ReplaceIamInstanceProfileAssociation",
            "ec2:CreateTags",
            "ec2:DeleteTags",
            "ec2:GetConsoleOutput"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:ReplaceRoute",
            "ec2:CreateRoute",
            "ec2:CreateRouteTable",
            "ec2:AssociateRouteTable",
            "ec2:DeleteRouteTable"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "ec2:CreateSubnet",
            "ec2:CreateVpc",
            "ec2:DeleteSubnet",
            "ec2:DeleteVpc",
            "ec2:AssociateVpcCidrBlock",
            "ec2:ModifySubnetAttribute",
            "ec2:CreateSecurityGroup",
            "ec2:DeleteSecurityGroup",
            "ec2:CreateInternetGateway",
            "ec2:DetachInternetGateway",
            "ec2:DeleteInternetGateway",
            "ec2:AttachInternetGateway",
            "ec2:CreateVpcEndpointServiceConfiguration",
            "ec2:DeleteVpcEndpointServiceConfigurations",
            "ec2:CreateVpcEndpoint",
            "ec2:DeleteVpcEndpoints",
            "ec2:CreateTransitGateway",
            "ec2:SearchTransitGatewayRoutes",
            "ec2:ReplaceTransitGatewayRoute",
            "ec2:CreateTransitGatewayRoute",
            "ec2:AssociateTransitGatewayRouteTable",
            "ec2:CreateTransitGatewayVpcAttachment",
            "ec2:CreateTransitGatewayRouteTable",
            "ec2:DeleteTransitGatewayVpcAttachment",
            "ec2:DeleteTransitGatewayRouteTable",
            "ec2:DisassociateTransitGatewayRouteTable",
            "ec2:AuthorizeSecurityGroupIngress"
        ],
        "Resource": "*"
    },
    {
        "Effect": "Allow",
        "Action": [
            "elasticloadbalancing:Describe*",
            "elasticloadbalancing:Get*",
            "elasticloadbalancing:DeleteListener",
            "elasticloadbalancing:DeleteTargetGroup",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:DeregisterTargets",
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:CreateTargetGroup",
            "elasticloadbalancing:CreateListener"
        ],
        "Resource": "*"
    },
    {
        "Action": "servicequotas:GetServiceQuota",
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
