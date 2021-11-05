resource "aws_iam_role" "stack-role" {
  name               = "ec2-s3-wordpress-bucket"
  assume_role_policy = file("clixxapp/assume-role-policy.json")
}

resource "aws_iam_policy" "stack-policy" {
  name        = "ec2-s3-policy"
  description = "This policy allows stack-role"
  policy      = file("clixxapp/policy-s3-bucket.json")
}

resource "aws_iam_policy_attachment" "stack-attach" {
    name       = "stack-attachment"
    roles      = [aws_iam_role.stack-role.name]
    policy_arn = aws_iam_policy.stack-policy.arn
  }

  resource "aws_iam_instance_profile" "stack_profile" {
  name  = "stack_profile"
  role = aws_iam_role.stack-role.name
}