provider "aws" {
  region = "ap-south-1"
}

# Fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "jenkins-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "jenkins-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "jenkins-gw"
  }
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associate Route Table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

# Security Group for SSH and HTTP
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-sg"
  }
}

# Variable: HTML content for each instance
variable "instance_html_content" {
  type = map(string)
  default = {
    nginx-server-1 = <<-HTML
      <html>
      <body style="background-color:#66BFFF; text-align:center;">
      <h1>Hi, I'm Anugrah</h1>
      <p>DevOps · Cloud · Content Creator</p>
      </body>
      </html>
    HTML

    nginx-server-2 = <<-HTML
      <html>
      <body style="background-color:rgb(229, 235, 240); text-align:center;">
      <h1>Hi, I'm Torian</h1>
      <p>DevOps · Cloud · yabalabala</p>
      </body>
      </html>
    HTML
  }
}

# EC2 Instances (shared setup, unique content)
resource "aws_instance" "nginx_servers" {
  for_each               = var.instance_html_content
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras enable nginx1
    yum clean metadata
    yum install nginx -y
    systemctl start nginx
    systemctl enable nginx

    cat <<EOT > /usr/share/nginx/html/index.html
    ${each.value}
    EOT
  EOF

  tags = {
    Name = each.key
  }
}

