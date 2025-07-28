output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.this.public_ip
}
