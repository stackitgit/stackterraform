terraform{
         backend "s3"{
                bucket= "stackbuckstatemike"
                key = "terraform.tfsate"
                    region="us-east-1"
                     dynamodb_table="statelock-tf"
                 }
 }


resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "App_Server" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type          = "t2.micro"
  iam_instance_profile   = "${aws_iam_instance_profile.stack_profile.name}"
  vpc_security_group_ids = ["${aws_security_group.WebDMZ.id}"]
   user_data = data.template_file.bootstrap.rendered
 // #THIS IS NEWER WAY OF USING TEMPLATE FILES user_data = templatefile("${path.module}/scripts/bootstrap.tpl", {DATABASE="mariadb-server"})
  key_name = aws_key_pair.mykeypair.key_name
  depends_on= [aws_db_instance.wordpressdbclixxrestore]

  tags = {
   Name = "App_Server"
   Environment = "production"
}
}



output "ip" {
  value = "${aws_instance.App_Server.public_ip}"
}
