resource "aws_vpc" "ionginx_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ionginx-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count = 3
  vpc_id = aws_vpc.ionginx_vpc.id
  cidr_block = cidrsubnet(aws_vpc.ionginx_vpc.cidr_block, 4, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = 3
  vpc_id = aws_vpc.ionginx_vpc.id
  cidr_block = cidrsubnet(aws_vpc.ionginx_vpc.cidr_block, 4, count.index + 3)

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ionginx_vpc.id

  tags = {
    Name = "ionginx-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.ionginx_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count = 3
  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}



resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet[0].id

  tags = {
    Name = "ionginx-nat"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.ionginx_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_assoc" {
  count = 3
  subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

output "vpc_id" {
  value = aws_vpc.ionginx_vpc.id
}

output "private_subnets" {
  value = aws_subnet.private_subnet[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
