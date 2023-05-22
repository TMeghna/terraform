provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "web" {
  ami             = "ami-08333bccc35d71140"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.dynamicwebtraffic.name]
}
//elatic IP address - that ip address won't change when that instance is restarted so
// its useful when we have a web server pointing to that public ip
resource "aws_eip" "elasticip" {
  instance = aws_instance.web.id
}
output "eip" {
  value = aws_eip.elasticip.public_ip
}

//security group - stateful firewall to allow ports in and ports out (inbound and outbound)
resource "aws_security_group" "webtraffic" {
  name = "allow HTTPS"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//dynamic blocks - iterate over lists when you want to set while running
variable "ingressports" {
  type    = list(number)
  default = [80, 443]
}

variable "egressports" {
  type    = list(number)
  default = [80, 443, 25]
}

resource "aws_security_group" "dynamicwebtraffic" {
  name = "allow HTTPS several ports"
  dynamic "ingress" {
    iterator = port
    for_each = var.ingressports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
  dynamic "egress" {
    iterator = port
    for_each = var.egressports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }
}

