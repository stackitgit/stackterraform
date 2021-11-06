resource "aws_iam_user" "user" {
  name          = var.username
  path          = "/"
  force_destroy = true
  tags=(module.STACK-TAGS.all_resource_tags)
}

resource "aws_iam_user_login_profile" "log-prof" {
  user    = aws_iam_user.user.name
  pgp_key = "keybase:stackterraform"
}


resource "aws_iam_group" "group" {
  name = var.group
}

###CHECK FOR EXISTENCE OF A POLICY, CREATE IF IT DOESN'T EXIST

# data "aws_iam_policy" "pol_check" {
#   name = "stack-pol"
# }

#locals {
#  policy_exists = data.aws_iam_policy.pol_check.arn
#}
resource "aws_iam_policy" "policy" {
  # count=data.aws_iam_policy.pol_check.arn=="" ? 0 : 1
  name        = var.policy
  description = "A policy that gives admin access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "stack-attach" {
  # count=data.aws_iam_policy.pol_check.arn=="" ? 0 : 1
  name       = "stack-attachment"
  groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_group_membership" "team" {
  name = "stack-group-membership"

  users = [
    aws_iam_user.user.name,
  ]

  group = aws_iam_group.group.name
}

