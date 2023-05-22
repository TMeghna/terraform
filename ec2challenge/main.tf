provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "DBserver" {
    ami = "ami-08333bccc35d71140"
    instance_type = "t2.micro"
}

resource "aws_instance" "WebServer" {
    ami = "ami-08333bccc35d71140"
    instance_type = "t2.micro"
    user_data = file("server-script.sh")
    security_groups = [aws_security_group.webtraffic.name]
}

resource "aws_eip" "public_ip" {
    instance = aws_instance.WebServer.id
}

variable "ingressports" {
    type = list(number)
    default = [ 80, 443 ]
}

resource "aws_security_group" "webtraffic" {
    name = "Allow Http"
    dynamic ingress {
       iterator = port
       for_each = var.ingressports
       content {
         from_port = port.value
         to_port = port.value
         cidr_blocks = [ "0.0.0.0/0" ]
         protocol = "tcp"
    }
    }
    dynamic egress {
       iterator = port
       for_each = var.ingressports
       content {
         from_port = port.value
         to_port = port.value
         cidr_blocks = [ "0.0.0.0/0" ]
         protocol = "tcp"
    }
    }
}

output "db_ip_address" {
    value = aws_instance.DBserver.private_ip  
}
output "web_ip_address" {
    value = aws_instance.WebServer.public_ip  
}