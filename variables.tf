variable "region" {
  description = "AWS region to launch resources in"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-"06cc5ebfb8571a147"  # Ubuntu AMI (change based on region)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

