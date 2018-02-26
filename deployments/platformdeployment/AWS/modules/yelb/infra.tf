resource "aws_vpc" "app_vpc" {
  cidr_block = "192.168.0.0/16"
  enable_dns_support = false
  enable_dns_hostnames = false
}

resource "aws_internet_gateway" "igw"{
  vpc_id = "${aws_vpc.app_vpc.id}"
}

resource "aws_route_table" "external_route" {
  vpc_id = "${aws_vpc.app_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_subnet" "app_subnet1"{
  vpc_id = "${aws_vpc.app_vpc.id}"
  cidr_block = "192.168.10.0/24"
  #map_public_ip_on_launch = true
}

resource "aws_subnet" "app_subnet2"{
  vpc_id = "${aws_vpc.app_vpc.id}"
  cidr_block = "192.168.20.0/24"
  #map_public_ip_on_launch = true
}

resource "aws_route_table_association" "external_route_associasion1" {
  subnet_id = "${aws_subnet.app_subnet1.id}"
  route_table_id = "${aws_route_table.external_route.id}"
}

resource "aws_route_table_association" "external_route_associasion2" {
  subnet_id = "${aws_subnet.app_subnet2.id}"
  route_table_id = "${aws_route_table.external_route.id}"
}

resource "aws_security_group" "web" {
  name = "web-secgroup"
  vpc_id = "${aws_vpc.app_vpc.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound internet access
  egress {
    from_port   = 5
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 5
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app" {
  name = "app-secgroup"
  vpc_id = "${aws_vpc.app_vpc.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4567
    to_port     = 4567
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["192.168.10.0/24"]
  }


  # Outbound internet access
  egress {
    from_port   = 5
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 5
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}