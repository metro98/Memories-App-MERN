
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "frontend" {
  ami           = "ami-0df8c184d5f6ae949" # Replace with a valid Ubuntu AMI ID for your region.
  instance_type = "t2.micro"

  tags = {
    Name = "frontend-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install docker.io -y"
    ]
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa") # Replace with the path to your private SSH key.
    host     = self.public_ip
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-0df8c184d5f6ae949" # Replace with a valid Ubuntu AMI ID for your region.
  instance_type = "t2.micro"

  tags = {
    Name = "backend-instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install docker.io -y"
    ]
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa") # Replace with the path to your private SSH key.
    host     = self.public_ip
  }
}

output "frontend_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_ip" {
  value = aws_instance.backend.public_ip
}

