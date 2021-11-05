output "password_output" {
  value = aws_iam_user_login_profile.log-prof.encrypted_password
}