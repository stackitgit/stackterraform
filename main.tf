terraform{
         backend "s3"{
                bucket= "stackbuckstatemike"
                //bucket= "stackstatebuck2"
                key = "terraform.tfstate"
                    region="us-east-1"
                     dynamodb_table="statelock-tf"
                 }
 }

locals {
  prefix  = "clixx"
  version = "-1-0-0"
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

/*
resource "aws_instance" "App_Server" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type          = var.instance_type
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

//Create VPC
resource "aws_vpc" "clixx_vpc" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = "clixxVPC"
  }
}

# Subnets : public
resource "aws_subnet" "public" {
  count = length(var.subnets_cidr)
  vpc_id = aws_vpc.terra_vpc.id
  cidr_block = element(var.subnets_cidr,count.index)
  availability_zone = element(var.azs,count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet-${count.index+1}"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra_igw.id
  }
  tags = {
    Name = "publicRouteTable"
  }
}

*/

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_route53_zone" "primary" {
  name = "stack-cloud.com"
}

/*
resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-1b"

  tags = {
    Name = "Default subnet for us-east-1b"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-1b"

  tags = {
    Name = "Default subnet for us-east-1b"
  }
}
resource "aws_default_subnet" "default_az3" {
  availability_zone = "us-east-1c"

  tags = {
    Name = "Default subnet for us-east-1c"
  }
}

resource "aws_default_subnet" "default_az4" {
  availability_zone = "us-east-1d"

  tags = {
    Name = "Default subnet for us-east-1d"
  }
}

resource "aws_default_subnet" "default_az5" {
  availability_zone = "us-east-1e"

  tags = {
    Name = "Default subnet for us-east-1e"
  }
}


resource "aws_default_subnet" "main_sub" {
   for_each = var.subnet_numbers
   //vpc_id= aws_default_vpc.default.id
   availability_zone= each.key
   //cidr_block= cidrsubnet(aws_default_vpc.default.cidr_block, 8, each.value)
}


/*resource "aws_subnet" "stack-subs" {
  for_each = var.subnet_numbers

  vpc_id            = aws_default_vpc.default.id
  availability_zone = each.key
  cidr_block        = cidrsubnet(aws_default_vpc.default.cidr_block, 8, each.value)
}


 resource "aws_subnet" "publicsubnets" {    # Creating Public Subnets
   vpc_id =  aws_default_vpc.default.id
   cidr_block = "${var.subnets_cidr}"        # CIDR block of public subnets
 }
 */


data "aws_subnet_ids" "default" {
  vpc_id = aws_default_vpc.default.id

  tags = {
    Tier = "default"
  }
}



//Create Application Load Balancer
resource "aws_alb" "stack-alb" {
  //for_each      = data.aws_subnet_ids.default.ids
  name            = "${local.prefix}${local.version}-alb"
  internal        = true
  security_groups = [aws_security_group.WebDMZ.id]
  //subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  subnets= data.aws_subnet_ids.default.*.id
  tags = { Name= "stack-alb"}
}


resource "aws_alb_target_group" "stack_alb_target_group" {
  name_prefix = "Stack"
  port        = 80
  protocol    = "HTTP"
  vpc_id = aws_default_vpc.default.id
  stickiness {
    type = "lb_cookie"
  }
  health_check {
    path                = "/index.php"
    matcher             = "200"
    protocol            = "HTTP"
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
  port              = "80"
  protocol          = "HTTP"
  //ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  //certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    target_group_arn = aws_alb_target_group.stack_alb_target_group.arn
    type             = "forward"
  }
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = concat(aws_alb.stack-alb.*.dns_name, [""])[0]
}
//Create Launch Configuration

resource "aws_launch_configuration" "launch_config" {
  lifecycle {
    create_before_destroy = true
  }

  name_prefix = "${local.prefix}_${local.version}-"

  image_id = var.AMIS[var.AWS_REGION]
  instance_type = var.instance_type
  iam_instance_profile   = "${aws_iam_instance_profile.stack_profile.name}"
  key_name = aws_key_pair.mykeypair.key_name
  associate_public_ip_address = true

  security_groups = [aws_security_group.WebDMZ.id]
  depends_on= [aws_db_instance.wordpressdbclixxrestore, aws_alb.stack-alb]

  root_block_device {
    volume_size           = 10
    encrypted             = false
    delete_on_termination = true
  }

  user_data = data.template_file.bootstrap.rendered
}

//Create Autoscaling Group


resource "aws_autoscaling_group" "clixx_asg" {
  for_each      = data.aws_subnet_ids.default.ids
  lifecycle {
    create_before_destroy = true
    ignore_changes = [load_balancers, target_group_arns]
  }

  name                      = "${local.prefix}_${local.version}-asg"
  launch_configuration      = aws_launch_configuration.launch_config.id
  min_size                  = var.min_size
  max_size                  = var.max_size
  wait_for_elb_capacity     = var.min_size
  wait_for_capacity_timeout = "30m"
  health_check_grace_period = 720
  health_check_type         = "ELB"
  default_cooldown          = 30
  //vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  vpc_zone_identifier=each.value

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
      tag {
    key                 = "Name"
    value               = "CliXX-ASG"
    propagate_at_launch = true
  }
}



resource "aws_autoscaling_attachment" "asg_attachment_stack" {
  autoscaling_group_name = aws_autoscaling_group.clixx_asg.id
  alb_target_group_arn   = aws_alb_target_group.stack_alb_target_group.arn
}


resource "aws_autoscaling_policy" "scale_up_policy" {
  name                      = "CliXX Scale Up"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = aws_autoscaling_group.clixx_asg.name
  estimated_instance_warmup = 30
  policy_type               = "StepScaling"

  step_adjustment {
    metric_interval_lower_bound = "0"
    metric_interval_upper_bound = "7"
    scaling_adjustment          = 1
  }

  step_adjustment {
    metric_interval_lower_bound = "7"
    metric_interval_upper_bound = "15"
    scaling_adjustment          = 2
  }

  step_adjustment {
    metric_interval_lower_bound = "15"
    scaling_adjustment          = 3
  }
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "Clixx Scale Down"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.clixx_asg.name
  policy_type            = "SimpleScaling"
  scaling_adjustment     = -1
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "CliXX Scale Up"
  alarm_description   = "Scale up for average CPUUtilization >= 75%"
  actions_enabled     = true
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 3
  threshold           = 75
  unit                = "Percent"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  alarm_actions = [
    aws_autoscaling_policy.scale_up_policy.arn,
  ]

  dimensions= {
    AutoScalingGroupName = aws_autoscaling_group.clixx_asg.name
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "Logstash Scale Down"
  alarm_description   = "Scale down for average CPUUtilization <= 40%"
  actions_enabled     = true
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 8
  threshold           = 40
  unit                = "Percent"
  comparison_operator = "LessThanOrEqualToThreshold"

  alarm_actions = [
    aws_autoscaling_policy.scale_down_policy.arn,
  ]

  dimensions= {
    AutoScalingGroupName = aws_autoscaling_group.clixx_asg.name
  }
}

/*
resource "aws_route53_record" "clixx_rt53" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.stack-cloud.com"
  type    = "A"
  ttl     = "300"
  records = [aws_alb.stack-alb.id]
}


resource "aws_acm_certificate" "cert" {
  domain_name       = "stack-cloud.com"
  validation_method = "DNS"
  tags = { Name= "stack-cert"}
  lifecycle {
    create_before_destroy = true
  }
}
*/






/*
output "ip" {
  value = "${aws_instance.App_Server.public_ip}"
}

output "ip" {
  value = "${aws_autoscaling_group.clixx_asg.public_ips}"
}*/