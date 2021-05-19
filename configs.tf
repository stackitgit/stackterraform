data "template_file" "bootstrap" {
    template = file(format("%s/scripts/bootstrap.tpl", path.module))
    vars={
       DATABASE="mariadb-server"
       DB_NAME=var.DB_NAME
       DB_USER=var.DB_USER
       DB_PASSWORD=var.RDS_PASSWORD
       DB_HOST=var.DB_HOST
       LB=aws_alb.stack-alb.dns_name
       //bucket_name = "${aws_s3_bucket.cloudtrail-logs.bucket}"
       //key_prefix = "AWSLogs/*" 
    }
}

data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = "creds"
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

data "template_file" "wp-config" {
  template = file(format("%s/config/wp-config.php", path.module))
  vars = {
    db_username=local.db_creds.username
    db_password=local.db_creds.password
    db_name=local.db_creds.db_name
    db_host=var.DB_HOST
  }
}

resource "aws_ssm_parameter" "wp-config-parameter" {
  name      = "${local.ssm_parameter_path}/var/www/html/wp-config.php"
  type      = "SecureString"
  value     = base64encode(data.template_file.nginx.rendered)
  overwrite = "true"
}

/*
data "template_file" "wp-config.php" {
    template = file(format("%s/config/wp-config.php", path.module))
    vars={
       DB_NAME="wordpressdb"
       DB_USER="wordpressuser"
       DB_PASSWORD=var.RDS_PASSWORD
       DB_HOST=aws_db_instance.wordpressdbclixxrestore.address
       //bucket_name = "${aws_s3_bucket.cloudtrail-logs.bucket}"
       //key_prefix = "AWSLogs/*" 
    }
}
*/