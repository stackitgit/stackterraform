output "password_out" {
  description = "Returns the password output"
  value       = module.STACK-IAM.password_output
#   #value       = "ssh -i ${module.ssh-key.key_name}.pem ec2-user@${module.ec2.public_ip}"
}
