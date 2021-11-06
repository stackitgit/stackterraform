variable "required_tags"{
description="Tags required to be specified on all resources"
type=object({
  Environment=string
  OwnerEmail=string
})
validation{
   condition=var.required_tags.OwnerEmail !="" && var.required_tags.OwnerEmail == lower(var.required_tags.OwnerEmail)
   error_message= "OwnerEmail must be lowercase and non-empty."
}
validation{
   condition = contains(["dev","test","uat","production"], var.required_tags.Environment)
   error_message="Environment must be in the following list: [dev,test,uat,production]."
}

}

# variable "tag_sets" {
#   description="Tag sets that are auto-prefixed"
#   type=map(map(string))
#   default={}
# }

# variable "server"{
# }


# variable "environment" {
# }



# variable "system" {
# }


# variable "owner_email" {
# }

# variable "backup" {
# }

# variable "support_email" {
# }

# variable "AWS_REGION" {
#   default = "us-east-1"
# }

# variable "AWS_ACCESS_KEY" {}

# variable "AWS_SECRET_KEY" {}
