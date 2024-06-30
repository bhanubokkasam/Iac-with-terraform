resource "aws_route53_zone" "main" {
  name = "example.com"
}

resource "aws_route53_record" "nginx" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "nginx.example.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.nat_eip.public_ip]
}

variable "nat_gateway_id" {}
