output "password_out" {
  description = "Returns the password output"
  value       = module.STACK-IAM.password_output
#   #value       = "ssh -i ${module.ssh-key.key_name}.pem ec2-user@${module.ec2.public_ip}"
}

# output "server_tags" {
#   description = "Returns a tag set"
#   value       = module.STACK-TAGS.server_tag
# }

output "all_resource_tags" {
  description = "Returns a tag set"
  value       = module.STACK-TAGS.all_resource_tags
}
