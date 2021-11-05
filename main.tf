module "STACK-IAM" {
    # for_each=toset(var.username)
    source="./STACK-IAM"
    username=var.username
    group=var.group
    policy=var.policy
    AWS_SECRET_KEY=var.AWS_SECRET_KEY
    AWS_ACCESS_KEY=var.AWS_ACCESS_KEY
    AWS_REGION=var.AWS_REGION

    providers = {
    aws = aws.use2
  }


}

