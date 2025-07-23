output "instance_public_ips" {
  value = [for instance in aws_instance.nginx_server : instance.public_ip]
}

