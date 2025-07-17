provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "nginx_server" {
  ami           = "ami-03f4878755434977f" # Amazon Linux 2 AMI for ap-south-1
  instance_type = "t2.micro"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl start nginx
              systemctl enable nginx
            EOF

  tags = {
    Name = "nginx-jenkins-instance"
  }
}


