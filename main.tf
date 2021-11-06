# module "STACK-IAM" {
#     # for_each=toset(var.username)
#     source="./STACK-IAM"
#     username=var.username
#     group=var.group
#     policy=var.policy
#     AWS_SECRET_KEY=var.AWS_SECRET_KEY
#     AWS_ACCESS_KEY=var.AWS_ACCESS_KEY
#     AWS_REGION=var.AWS_REGION

#     providers = {
#     aws = aws.use2
#   }


# }


module "STACK-TAGS" {
    # source="github.com/stackitgit/stackterraform.git?ref=stackmodules/STACK-IAM"
    source="./STACK_TAGS"

    required_tags={
      Environment=var.environment,
      OwnerEmail=var.OwnerEmail
    }

    tag_sets={
      clixx={
        system=var.subsystem,
        backup=var.backup,
        region=var.region,


      }
    }
}

module "STACK-IAM" {
    # for_each=toset(var.username)
    source="github.com/stackitgit/stackterraform.git?ref=stackmodules/STACK-IAM"
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


