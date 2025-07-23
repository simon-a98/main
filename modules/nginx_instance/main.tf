locals {
  html_map = {
    "nginx-server-1" = <<-HTML
      <html>
      <body style="background-color:#66BFFF; text-align:center;">
      <h1>Hi, I'm Anugrah</h1>
      <p>DevOps · Cloud · Content Creator</p>
      </body>
      </html>
    HTML

    "nginx-server-2" = <<-HTML
      <html>
      <body style="background-color:#E5EBF0; text-align:center;">
      <h1>Hi, I'm Torian</h1>
      <p>DevOps · Cloud · yabalabala</p>
      </body>
      </html>
    HTML
  }

  html_content = lookup(local.html_map, var.instance_name, "<h1>Default Page</h1>")
}

resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras enable nginx1
    yum clean metadata
    yum install nginx -y
    systemctl start nginx
    systemctl enable nginx

    cat <<EOT > /usr/share/nginx/html/index.html
    ${local.html_content}
    EOT
  EOF

  tags = {
    Name = var.instance_name
  }
}
