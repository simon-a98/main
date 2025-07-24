output "nginx_instance_ips" {
  description = "Public IPs of the Nginx instances"
  value = {
    for name, instance in aws_instance.nginx_servers :
    name => instance.public_ip
  }
}


