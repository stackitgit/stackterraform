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

/*
resource "aws_acm_certificate" "cert" {
  domain_name       = "stack-cloud.com"
  validation_method = "DNS"
  tags = { Name= "stack-cert"}
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb" "stack-alb" {
  name            = "stack-alb"
  internal        = true
  security_groups = [aws_security_group.WebDMZ.id]
  tags = { Name= "stack-alb"}
}


resource "aws_alb_target_group" "stack_alb_target_group" {
  name_prefix = "Stack"
  port        = 443
  protocol    = "HTTPS"
  stickiness {
    type = "lb_cookie"
  }
  health_check {
    path                = "/user/login"
    matcher             = "200"
    protocol            = "HTTPS"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = { Name= "stack-alb-tg"}
}

resource "aws_alb_listener" "stack_alb_secure_listener" {
  load_balancer_arn = aws_alb.stack-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    target_group_arn = aws_alb_target_group.stack_alb_target_group.arn
    type             = "forward"
  }
}


*/

output "ip" {
  value = "${aws_instance.App_Server.public_ip}"
}
