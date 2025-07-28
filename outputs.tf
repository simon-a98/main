output "nginx_instance_1_public_ip" {
  description = "Public IP of the first nginx server"
  value       = module.nginx_instance_1.public_ip
}

output "nginx_instance_2_public_ip" {
  description = "Public IP of the second nginx server"
  value       = module.nginx_instance_2.public_ip
}




