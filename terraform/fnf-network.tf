// vpc configuration
resource "aws_vpc" "fnf-vpc" {
  cidr_block = "10.0.0.0/16"
}

// subnet public east-1a
resource "aws_subnet" "fnf-subnet-public1-us-east-1a" {
  vpc_id            = aws_vpc.fnf-vpc.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "fnf-subnet-public1 | us-east-1a"
  }
}

// subnet private east-1a
resource "aws_subnet" "fnf-subnet-private1-us-east-1a" {
  vpc_id            = aws_vpc.fnf-vpc.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "fnf-subnet-private1 | us-east-1a"
  }
}

// subnet public east-1b
resource "aws_subnet" "fnf-subnet-public2-us-east-1b" {
  vpc_id            = aws_vpc.fnf-vpc.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "fnf-subnet-public2 | us-east-1b"
  }
}

// subnet private east-1b
resource "aws_subnet" "fnf-subnet-private2-us-east-1b" {
  vpc_id            = aws_vpc.fnf-vpc.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "fnf-subnet-private2 | us-east-1b"
  }
}

// route table public
resource "aws_route_table" "fnf-rtb-public" {
  vpc_id = aws_vpc.fnf-vpc.id
  tags = {
    "Name" = "fnf-rtb-public"
  }
}

// route table private
resource "aws_route_table" "fnf-rtb-private" {
  vpc_id = aws_vpc.fnf-vpc.id
  tags = {
    "Name" = "fnf-rtb-private"
  }
}

// route table associations
resource "aws_route_table_association" "fnf-subnet-public1-us-east-1a_subnet" {
  subnet_id      = aws_subnet.fnf-subnet-public1-us-east-1a.id
  route_table_id = aws_route_table.fnf-rtb-public.id
}

resource "aws_route_table_association" "fnf-subnet-private1-us-east-1a_subnet" {
  subnet_id      = aws_subnet.fnf-subnet-private1-us-east-1a.id
  route_table_id = aws_route_table.fnf-rtb-private.id
}

resource "aws_route_table_association" "fnf-subnet-public2-us-east-1b_subnet" {
  subnet_id      = aws_subnet.fnf-subnet-public2-us-east-1b.id
  route_table_id = aws_route_table.fnf-rtb-public.id
}

resource "aws_route_table_association" "fnf-subnet-private2-us-east-1b_subnet" {
  subnet_id      = aws_subnet.fnf-subnet-private2-us-east-1b.id
  route_table_id = aws_route_table.fnf-rtb-private.id
}

// elastic IP
resource "aws_eip" "nat" {
  vpc = true
}

// gateway
resource "aws_internet_gateway" "fnf-igw" {
  vpc_id = aws_vpc.fnf-vpc.id

  tags = {
    "Name" = "fnf-igw"
  }
}

// nat gateway
resource "aws_nat_gateway" "fnf-nat-public1-us-east-1a" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.fnf-subnet-public1-us-east-1a.id
  depends_on = [ aws_internet_gateway.fnf-igw ]
}

// route public internet gateway
resource "aws_route" "fnf-public-igw" {
  route_table_id         = aws_route_table.fnf-rtb-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.fnf-igw.id
}

// route private nat gateway
resource "aws_route" "fnf-private-ngw" {
  route_table_id         = aws_route_table.fnf-rtb-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.fnf-nat-public1-us-east-1a.id
}