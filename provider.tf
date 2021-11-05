# provider "aws" {
#   region = var.AWS_REGION
# access_key = var.AWS_ACCESS_KEY
# secret_key = var.AWS_SECRET_KEY
# }

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}

provider "aws" {
  alias  = "use2"
  region = "us-east-2"
}
