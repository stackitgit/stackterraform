variable "required_tags"{
description="Tags required to be specified on all resources"
type=object({
  Environment=string,
  OwnerEmail=string,
  System=string,
  Backup=string,
  Region=string
})
validation{
   condition=var.required_tags.OwnerEmail !="" && var.required_tags.OwnerEmail == lower(var.required_tags.OwnerEmail)
   error_message= "OwnerEmail must be lowercase and non-empty."
}
validation{
   condition = contains(["dev","test","uat","production"], var.required_tags.Environment)
   error_message="Environment must be in the following list: [dev,test,uat,production]."
}

validation{
  condition=var.required_tags.System !="" && var.required_tags.System==lower(var.required_tags.System)
  error_message="System must be lowercase and non-empty."
}

validation{
   condition = contains(["YES","yes","NO","no","Yes","No"], var.required_tags.Backup)
   error_message="Backup must be in the following list: [YES,yes,NO,no,Yes,No]."
}

validation{
   condition=var.required_tags.Region !="" && var.required_tags.Region == lower(var.required_tags.Region)
   error_message= "Region must be lowercase and non-empty."
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
