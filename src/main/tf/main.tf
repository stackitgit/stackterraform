resource "aws_instance" "server" {
  for_each = var.instance_configs

  ami           = each.value.ami
  instance_type = each.value.instance_type

  tags = {
    Name = each.value.name_tag
  }
}


