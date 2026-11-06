output "database_public_ip" {
  description = "Public IPv4 address of this account's database host."
  value       = aws_instance.database.public_ip
}

output "database_security_group_id" {
  description = "Security group ID for the database host."
  value       = aws_security_group.database.id
}

output "application_public_ip" {
  description = "Public IPv4 address of this account's NairobiPulse application host."
  value       = aws_instance.application.public_ip
}

output "application_security_group_id" {
  description = "Security group ID for the NairobiPulse application host."
  value       = aws_security_group.application.id
}
