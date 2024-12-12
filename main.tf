# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"  # Replace with your desired region
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "Main VPC"
  }
}

# Create a subnet within the VPC
resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "Main Subnet"
  }
}

# Create a security group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Be cautious with this in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Allow SSH"
  }
}

# Create an EC2 instance
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI (update with latest AMI)
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  # Optional: Add a key pair for SSH access
  key_name = "your-key-pair-name"  # Replace with your existing key pair

  # Optional: Add user data for initial setup
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF

  # Optional: Add tags for better resource management
  tags = {
    Name        = "WebServer"
    Environment = "Development"
    Terraform   = "true"
  }

  # Optional: Root volume configuration
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    delete_on_termination = true
  }
}

# Optional: Create an Elastic IP
resource "aws_eip" "web_eip" {
  instance = aws_instance.web.id
  vpc      = true

  tags = {
    Name = "WebServer EIP"
  }
}

# Outputs
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.web.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_eip.web_eip.public_ip
}
