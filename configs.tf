locals {
  wp_creds = jsondecode(
    data.aws_secretsmanager_secret_version.wpcreds.secret_string
  )
  ssm_parameter_path="/stack"
  db_host=var.DB_HOST
}

data "template_file" "bootstrap" {
    template = file(format("%s/scripts/bootstrap.tpl", path.module))
    vars={
       DATABASE="mariadb-server"
       DB_NAME=var.DB_NAME
       DB_USER=var.DB_USER
       DB_PASSWORD=var.RDS_PASSWORD
       DB_HOST=local.db_host
       LB=aws_alb.stack-alb.dns_name
       //bucket_name = "${aws_s3_bucket.cloudtrail-logs.bucket}"
       //key_prefix = "AWSLogs/*" 
    }
}


data "aws_secretsmanager_secret_version" "wpcreds" {
  # Fill in the name you gave to your secret
  secret_id = "creds"
}



data "template_file" "wp-config" {
  template = file(format("%s/configs/wp-config.php", path.module))
  vars = {
    db_username=local.wp_creds.username
    db_password=local.wp_creds.password
    db_name=local.wp_creds.db_name
    db_host=local.db_host
  }
}
resource "aws_ssm_parameter" "wp-config-parameter" {
  name      = "${local.ssm_parameter_path}/var/www/html/wp-config.php"
  type      = "SecureString"
  //value     = base64encode(data.template_file.wp-config.rendered)
  value     = data.template_file.wp-config.rendered
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