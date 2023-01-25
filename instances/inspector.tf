resource "aws_inspector_resource_group" "stack_res" {
  tags = {
    Name = "Test_Instance"
    Env  = "dev"
  }
  depends_on = [aws_instance.application_server]
}

resource "aws_inspector_assessment_target" "assessment" {
  name               = "Hardening Assessment"
  resource_group_arn = aws_inspector_resource_group.stack_res.arn
}

resource "aws_inspector_assessment_template" "stack_hardening_rules" {
  name       = "stack_rules"
  target_arn = aws_inspector_assessment_target.assessment.arn
  duration   = 3600

  rules_package_arns = [
    "arn:aws:inspector:us-east-1:758058086616:rulespackage/0-9hgA516p",
    "arn:aws:inspector:us-east-1:758058086616:rulespackage/0-H5hpSawc",
    "arn:aws:inspector:us-east-1:758058086616:rulespackage/0-JJOtZiqQ",
    "arn:aws:inspector:us-east-1:758058086616:rulespackage/0-vg5GGHSD",
  ]
}

output "assessment_template_arn" {
    value=aws_inspector_assessment_template.stack_hardening_rules.arn
}