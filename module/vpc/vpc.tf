#VPC, Subnet
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  instance_tenancy     = "default"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_public1
  availability_zone = var.az1
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_public2
  availability_zone = var.az2
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_private1
  availability_zone = var.az1
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.cidr_private2
  availability_zone = var.az2
}

#gateway
resource "aws_internet_gateway" "igw"{
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_nat_gateway" "nat_gateway"{
  allocation_id     = aws_eip.nat_gateway.id
  subnet_id         = aws_subnet.public1.id
  depends_on        = [aws_internet_gateway.igw]
}

resource "aws_eip" "nat_gateway"{
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

#route table
#public
resource "aws_route_table" "public"{
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_route_table_association" "public1"{
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2"{
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public"{
  route_table_id  = aws_route_table.public.id
  gateway_id      = aws_internet_gateway.igw.id
  destination_cidr_block   = var.cidr_internet_gateway
}

#route table
#private
resource "aws_route_table" "private1"{
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_route_table_association" "private1"{
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route" "private1"{
  route_table_id  = aws_route_table.private1.id
  gateway_id      = aws_nat_gateway.nat_gateway.id
  destination_cidr_block   = var.cidr_nat_gateway
}

resource "aws_route_table" "private2"{
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_route_table_association" "private2"{
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}

resource "aws_route" "private2"{
  route_table_id  = aws_route_table.private2.id
  gateway_id      = aws_nat_gateway.nat_gateway.id
  destination_cidr_block   = var.cidr_nat_gateway
}