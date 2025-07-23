output "nginx_instance_ips" {
  value = [
    aws_instance.nginx_server_1.public_ip,
    aws_instance.nginx_server_2.public_ip
  ]
}

