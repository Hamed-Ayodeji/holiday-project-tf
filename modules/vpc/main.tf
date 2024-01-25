# create a vpc

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

##################################################################################

# create a public subnet

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 4, 0)
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

##################################################################################

# create 2 private subnets

resource "aws_subnet" "private_subnets" {
  for_each = {
    private_subnet1 = 1
    private_subnet2 = 2
  }
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 4, each.value)
  availability_zone = data.aws_availability_zones.available.names[each.value]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-subnet-${each.key}"
  }
}

##################################################################################

# create an internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

##################################################################################

# create a public route table

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

##################################################################################

# create a public route table association

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

##################################################################################

# create an elastic ip for nat gateway

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

##################################################################################

# create a nat gateway

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.project_name}-nat-gateway"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}

##################################################################################

# create a private route table

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.project_name}-private-route-table"
  }
}

##################################################################################

# create a private route table association

resource "aws_route_table_association" "private_route_table_association" {
  for_each = {
    private_subnet1 = aws_subnet.private_subnets["private_subnet1"].id
    private_subnet2 = aws_subnet.private_subnets["private_subnet2"].id
  }
  subnet_id = each.value
  route_table_id = aws_route_table.private_route_table.id
}

##################################################################################