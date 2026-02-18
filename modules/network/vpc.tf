data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "publicsubnet" {
  count = 2
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = cidrsubnet(aws_vpc.myvpc.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "publicsubnet--${count.index}"
  } 
}

resource "aws_subnet" "privatesubnet" {
  count = 2

  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = cidrsubnet(aws_vpc.myvpc.cidr_block, 8, count.index + 10)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-${count.index}"
  }
}


resource "aws_internet_gateway" "module_igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "my-internet-gateway"
  }
  
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.module_igw.id
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count = length(aws_subnet.publicsubnet)
  subnet_id      = aws_subnet.publicsubnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name = "my-nat-eip"
  }  
}

resource "aws_nat_gateway" "module_natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.publicsubnet[0].id
  depends_on = [aws_internet_gateway.module_igw]
  tags = {
    Name = "my-nat-gateway"
  } 
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.module_natgw.id
  }
  depends_on = [ aws_nat_gateway.module_natgw ]
}

resource "aws_route_table_association" "private_rt_assoc" {
  count = length(aws_subnet.privatesubnet)
  subnet_id      = aws_subnet.privatesubnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
