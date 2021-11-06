 variable "AWS_ACCESS_KEY" {}

 variable "AWS_SECRET_KEY" {}


variable "AWS_REGION" {
  default = "us-east-1"
}


variable "AMIS" {
  type = map(string)
  default = {
   # us-east-1 = "ami-13be557e"
    us-east-1 = "ami-08f3d892de259504d"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}


variable "username"{
  # type    = list(string)
  # default=["mike"]
  default="mike"
}

variable "group" {
  default="stack-group1"
}

variable "policy" {
  default="stack-poli1"
}

variable "server"{
  default=""
}


variable "environment" {
  default="dev"
}

variable "region" {
  default="region"
}

variable "subsystem" {
  default="CliXX"
}


variable "OwnerEmail" {
  default="michael.ojejinmi@stackitsolutions.com"
}

variable "backup" {
  default="Yes"
}

variable "support_email" {
  default="support@stackitsolutions.com"
}
