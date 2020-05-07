## Create VPC for Polaris Exocompute
resource "aws_vpc" "va_exocompute" {
  cidr_block       = "172.26.48.0/22"
  instance_tenancy = "default"

  tags = {
    Name = "va_exocompute"
  }
}

## Create private (internal) subnets
resource "aws_subnet" "va_exocompute_i1" {
  vpc_id     = aws_vpc.va_exocompute.id
  cidr_block = "172.26.48.0/24"
  availability_zone = var.AZ1

  tags = {
    Name = "va_exocompute_i1"
    Visibility = "private"
  }
}

resource "aws_subnet" "va_exocompute_i2" {
  vpc_id     = aws_vpc.va_exocompute.id
  cidr_block = "172.26.49.0/24"
  availability_zone = var.AZ2

  tags = {
    Name = "va_exocompute_i2"
    Visibility = "private"
  }
}

## Create public (external) subnets
resource "aws_subnet" "va_exocompute_e1" {
  vpc_id     = aws_vpc.va_exocompute.id
  cidr_block = "172.26.50.0/24"
  availability_zone = var.AZ1

  tags = {
    Name = "va_exocompute_e1"
    Visibility = "public"
  }
}

resource "aws_subnet" "va_exocompute_e2" {
  vpc_id     = aws_vpc.va_exocompute.id
  cidr_block = "172.26.51.0/24"
  availability_zone = var.AZ2

  tags = {
    Name = "va_exocompute_e2"
    Visibility = "public"
  }
}

## IGW, EIP, and NAT
resource "aws_internet_gateway" "va_igw_exocompute" {
  vpc_id = aws_vpc.va_exocompute.id
  tags = {
    Name = "va_igw_exocompute"
  }
}

resource "aws_eip" "va_eip_exocompute" {
  vpc = "true"
}

resource "aws_nat_gateway" "va_nat_exocompute" {
  allocation_id = aws_eip.va_eip_exocompute.id
  subnet_id     = aws_subnet.va_exocompute_e1.id
  tags = {
    Name = "va_nat_exocompute"
  }
}

## Private Route Table
resource "aws_route_table" "va_exocompute_rtb_private" {
  vpc_id = aws_vpc.va_exocompute.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.va_nat_exocompute.id
  }
  tags = {
    Name = "va_exocompute_rtb_private"
  }
  depends_on = [aws_nat_gateway.va_nat_exocompute]
}

resource "aws_route_table_association" "va_exocompute_rtb_1" {
  subnet_id      = aws_subnet.va_exocompute_i1.id
  route_table_id = aws_route_table.va_exocompute_rtb_private.id
}

resource "aws_route_table_association" "va_exocompute_rtb_2" {
  subnet_id      = aws_subnet.va_exocompute_i2.id
  route_table_id = aws_route_table.va_exocompute_rtb_private.id
}

## Public Route Table
resource "aws_route_table" "va_exocompute_rtb_public" {
  vpc_id = aws_vpc.va_exocompute.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.va_igw_exocompute.id
  }
  tags = {
    Name = "va_exocompute_rtb_public"
  }
  depends_on = [aws_internet_gateway.va_igw_exocompute]
}

resource "aws_route_table_association" "va_exocompute_rtb_public_1" {
  subnet_id      = aws_subnet.va_exocompute_e1.id
  route_table_id = aws_route_table.va_exocompute_rtb_public.id
}

resource "aws_route_table_association" "va_exocompute_rtb_public_2" {
  subnet_id      = aws_subnet.va_exocompute_e2.id
  route_table_id = aws_route_table.va_exocompute_rtb_public.id
}