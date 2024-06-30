resource "aws_launch_template" "nginx" {
  name_prefix   = "nginx-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              systemctl start nginx
              EOF

  network_interfaces {
    associate_public_ip_address = false
    subnet_id = var.private_subnets[0]
    security_groups = [aws_security_group.ec2_sg.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  vpc_zone_identifier  = var.private_subnets
  launch_template {
    id      = aws_launch_template.nginx.id
    version = "$Latest"
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
