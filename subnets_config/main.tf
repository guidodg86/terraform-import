
provider "aws" {
  region = "eu-central-1"
}


resource "aws_vpc" "fraa_1" {
  cidr_block = "10.25.0.0/16"

  tags = {
    Name = "fraa_1"
  }
}

resource "aws_vpc" "fraa_2" {
  cidr_block = "10.35.0.0/16"

  tags = {
    Name = "fraa_2"
  }
}

resource "aws_internet_gateway" "fraa_1_igw" {
  vpc_id = aws_vpc.fraa_1.id

  tags = {
    Name = "fraa_1_igw"
  }
}

resource "aws_subnet" "fraa_1_1a" {
  vpc_id            = aws_vpc.fraa_1.id
  cidr_block        = "10.25.0.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "fraa_1_1a"
  }
}

resource "aws_subnet" "fraa_1_1b" {
  vpc_id            = aws_vpc.fraa_1.id
  cidr_block        = "10.25.1.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "fraa_1_1b"
  }
}

resource "aws_subnet" "fraa_1_1c" {
  vpc_id            = aws_vpc.fraa_1.id
  cidr_block        = "10.25.3.0/24"
  availability_zone = "eu-central-1c"

  tags = {
    Name = "fraa_1_1c"
  }
}

resource "aws_subnet" "fraa_2_1a" {
  vpc_id            = aws_vpc.fraa_2.id
  cidr_block        = "10.35.0.0/24"
  availability_zone = "eu-central-1a"

  tags = {
    Name = "fraa_2_1a"
  }
}

resource "aws_subnet" "fraa_2_1b" {
  vpc_id            = aws_vpc.fraa_2.id
  cidr_block        = "10.35.1.0/24"
  availability_zone = "eu-central-1b"

  tags = {
    Name = "fraa_2_1b"
  }
}

resource "aws_subnet" "fraa_2_1c" {
  vpc_id            = aws_vpc.fraa_2.id
  cidr_block        = "10.35.3.0/24"
  availability_zone = "eu-central-1c"

  tags = {
    Name = "fraa_2_1c"
  }
}

resource "aws_eip" "nat_gw_eip" {
  domain = "vpc"

  tags = {
    Name = "nat_gw_eip"
  } 

}


resource "aws_nat_gateway" "fraa_1_1a_nat_gateway" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.fraa_1_1a.id

  tags = {
    Name = "gw_NAT_fraa_1_1a"
  }

  # For proper order (recommended by hashicorp)
  depends_on = [aws_internet_gateway.fraa_1_igw]
}

resource "aws_route_table" "route_table_fraa_1_1a" {
  vpc_id = aws_vpc.fraa_1.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.fraa_1_1a_nat_gateway.id
  }

  tags = {
    Name = "default_to_internet_fraa_1_1a"
  }

}


resource "aws_route_table_association" "a_fraa_1_1a" {
  subnet_id      = aws_subnet.fraa_1_1a.id
  route_table_id = aws_route_table.route_table_fraa_1_1a.id
}

resource "aws_route_table_association" "a_fraa_1_1b" {
  subnet_id      = aws_subnet.fraa_1_1b.id
  route_table_id = aws_vpc.fraa_1.default_route_table_id 
}

resource "aws_route_table_association" "a_fraa_1_1c" {
  subnet_id      = aws_subnet.fraa_1_1c.id
  route_table_id = aws_vpc.fraa_1.default_route_table_id 
}

resource "aws_route_table_association" "a_fraa_2_1a" {
  subnet_id      = aws_subnet.fraa_2_1a.id
  route_table_id = aws_vpc.fraa_2.default_route_table_id 
}

resource "aws_route_table_association" "a_fraa_2_1b" {
  subnet_id      = aws_subnet.fraa_2_1b.id
  route_table_id = aws_vpc.fraa_2.default_route_table_id 
}

resource "aws_route_table_association" "a_fraa_2_1c" {
  subnet_id      = aws_subnet.fraa_2_1c.id
  route_table_id = aws_vpc.fraa_2.default_route_table_id 
}
