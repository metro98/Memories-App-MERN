provider "aws" {
  region = "us-east-1"
}

# Variable for Private Key
variable "private_key" {
  description = "Private SSH key for accessing instances"
  type        = string
}

# Security Group to Allow HTTP and SSH Traffic
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow public HTTP access
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow public SSH access (use cautiously)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Frontend Instance
resource "aws_instance" "frontend" {
  ami           = "ami-01816d07b1128cd2d" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = "frontend-instance"
  }

  security_groups = [aws_security_group.web_sg.name] # Attach security group

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y", # Install Docker on Amazon Linux
      "sudo service docker start",
      "sudo usermod -aG docker ec2-user" # Add ec2-user to the Docker group
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user" # Default user for Amazon Linux AMIs
    private_key = var.private_key
    host        = self.public_ip
  }
}

# Backend Instance
resource "aws_instance" "backend" {
  ami           = "ami-01816d07b1128cd2d" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = "backend-instance"
  }

  security_groups = [aws_security_group.web_sg.name] # Attach security group

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install docker -y", # Install Docker on Amazon Linux
      "sudo service docker start",
      "sudo usermod -aG docker ec2-user" # Add ec2-user to the Docker group
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user" # Default user for Amazon Linux AMIs
    private_key = var.private_key
    host        = self.public_ip
  }
}

# Outputs for Public IPs of Instances
output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_ip" {
  value = aws_instance.backend.public_ip
}
