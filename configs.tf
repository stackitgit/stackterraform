data "template_file" "bootstrap" {
    template = file(format("%s/scripts/bootstrap.tpl", path.module))
    vars={
       DATABASE="mariadb-server"
       DB_NAME=var.DB_NAME
       DB_USER=var.DB_USER
       DB_PASSWORD=var.RDS_PASSWORD
       DB_HOST=var.DB_HOST
       //bucket_name = "${aws_s3_bucket.cloudtrail-logs.bucket}"
       //key_prefix = "AWSLogs/*" 
    }
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