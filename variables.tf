 variable "AWS_ACCESS_KEY" {}

 variable "AWS_SECRET_KEY" {}


variable "AWS_REGION" {
  default = "us-east-1"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
   # us-east-1 = "ami-13be557e"
    //us-east-1 = "ami-08f3d892de259504d"
    us-east-1= "ami-stack-1.0/1.0.6"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "instance_type"{
  default ="t2.micro"
}
 variable "RDS_PASSWORD" {
 }

variable "INSTANCE_USERNAME" {
}

variable "PROD_DB_SNAPSHOT" {
    default = "wordpressdbclixxsnap"
}
variable "DB_USER" {
}
variable "DB_PASSWORD" {
}
variable "DB_HOST" {
}
variable "DB_NAME" {
}

variable "min_size" {
  default=1
}
variable "max_size" {
  default=4
}
variable "subnets_cidr" {
	type = "list"
	default = ["172.31.64.0/20", "172.31.16.0/20","172.31.32.0/20","172.31.0.0/20","172.31.80.0/20","172.31.48.0/20"]
}

variable "vpc_cidr" {
	default = "10.20.0.0/16"
}

variable "azs" {
	type = "list"
	default = ["us-east-1a", "us-east-1b","us-east-1c","us-east-1d","us-east-1e","us-east-1f"]
}


variable "subnet_numbers" {
  description = "Map from availability zone to the number that should be used for each availability zone's subnet"
  default     = {
    "us-east-1a" = 1
    "us-east-1b" = 2
    "us-east-1c" = 3
    "us-east-1d" = 4
    "us-east-1e" = 5
    "us-east-1f" = 6
  }
}

# variable "public_subnets" {}

# variable "private_subnets" {}

