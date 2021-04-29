/*resource "aws_db_instance" "prod" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.20"
  instance_class       = "db.t2.micro"
  identifier           = "wordpressdbclixxsnap"
  username             = "wordpressuser"
  password             = var.RDS_PASSWORD
  db_subnet_group_name = "default"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = true
}

data "aws_db_snapshot" "latest_prod_snapshot" {
  db_instance_identifier = aws_db_instance.prod.name
  most_recent            = true
}


resource "aws_db_instance" "wordpressdbclixxrestore" {
  instance_class      = "db.t2.micro"
  snapshot_identifier = data.aws_db_snapshot.latest_prod_snapshot.id
  identifier="wordpressdbclixxtest"
  skip_final_snapshot = true
  vpc_security_group_ids=[aws_security_group.WebDMZ.id]
  backup_retention_period = 0

  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
   tags = {
   Name = "CliXX-Rest"
   Environment = "Dev"
}
}

output "this_db_instance_address" {
  value = "${aws_db_instance.wordpressdbclixxrestore.address}"
}

*/


resource "aws_db_instance" "wordpressdbclixxrestore" {
  instance_class      = "db.t2.micro"
  snapshot_identifier = var.PROD_DB_SNAPSHOT
  identifier="wordpressdbclixx"
  #username= "wordpressuser"
  username=var.DB_USER
  password= var.RDS_PASSWORD
  skip_final_snapshot = true
  vpc_security_group_ids=[aws_security_group.WebDMZ.id]
  backup_retention_period = 0

  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
   tags = {
   Name = "CliXX-Rest"
   Environment = "Dev"
}
}

output "this_db_instance_address" {
  value = "${aws_db_instance.wordpressdbclixxrestore.address}"
}


