provider "aws" {
     region = "us-east-1"
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
    key_name = "ronin_key"
  security_groups = [aws_security_group.web_sg.name] # Attach security group




}

# Backend Instance
resource "aws_instance" "backend" {
  ami           = "ami-01816d07b1128cd2d" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  tags = {
    Name = "backend-instance"
  }
    key_name = "ronin_key"
    security_groups = [aws_security_group.web_sg.name] # Attach security group
 
}

# Outputs for Public IPs of Instances
output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_ip" {
  value = aws_instance.backend.public_ip
}
