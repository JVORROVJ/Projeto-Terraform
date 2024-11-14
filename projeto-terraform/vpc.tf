# Criando VPC fatcat
resource "aws_vpc" "fatcat_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "fatcat_VPC"
  }
}

# Criando o fatcat Internet Gateway
resource "aws_internet_gateway" "igw-fatcat" {
  vpc_id = aws_vpc.fatcat_vpc.id
  tags = {
    Name = "fatcat_IGW"
  }
}

# Criando fatcat Public Subnets
resource "aws_subnet" "fatcat_public_subnet_1" {
  vpc_id                  = aws_vpc.fatcat_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "fatcat_Public_Subnet_1"
  }
}

resource "aws_subnet" "fatcat_public_subnet_2" {
  vpc_id                  = aws_vpc.fatcat_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "fatcat_Public_Subnet_2"
  }
}

resource "aws_subnet" "fatcat_public_subnet_3" {
  vpc_id                  = aws_vpc.fatcat_vpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1c"
  tags = {
    Name = "fatcat_Public_Subnet_3"
  }
}

# Criando fatcat Private Subnets
resource "aws_subnet" "fatcat_private_subnet_1" {
  vpc_id            = aws_vpc.fatcat_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "fatcat_Private_Subnet_1"
  }
}

resource "aws_subnet" "fatcat_private_subnet_2" {
  vpc_id            = aws_vpc.fatcat_vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "fatcat_Private_Subnet_2"
  }
}

resource "aws_subnet" "fatcat_private_subnet_3" {
  vpc_id            = aws_vpc.fatcat_vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "fatcat_Private_Subnet_3"
  }
}

# Criando fatcat Route Table for Public Subnets

resource "aws_route_table" "fatcat_public_route" {
  vpc_id = aws_vpc.fatcat_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-fatcat.id
  }
}


# Associando Public Subnets no Public Route Table
resource "aws_route_table_association" "fatcat_public_subnet_1_association" {
  subnet_id      = aws_subnet.fatcat_public_subnet_1.id
  route_table_id = aws_route_table.fatcat_public_route.id
}

resource "aws_route_table_association" "fatcat_public_subnet_2_association" {
  subnet_id      = aws_subnet.fatcat_public_subnet_2.id
  route_table_id = aws_route_table.fatcat_public_route.id
}

resource "aws_route_table_association" "fatcat_public_subnet_3_association" {
  subnet_id      = aws_subnet.fatcat_public_subnet_3.id
  route_table_id = aws_route_table.fatcat_public_route.id
}

# Criando allocation ip 1 (Elastic IP)
resource "aws_eip" "fatcat_nat_eip_1" {
  depends_on = [aws_internet_gateway.igw-fatcat]
}

resource "aws_nat_gateway" "fatcat_nat_gateway_1" {
  allocation_id = aws_eip.fatcat_nat_eip_1.id
  subnet_id     = aws_subnet.fatcat_public_subnet_1.id
  tags = {
    Name = "fatcat_NAT_Gateway_1"
  }
}

resource "aws_eip" "fatcat_nat_eip_2" {
  depends_on = [aws_internet_gateway.igw-fatcat]
}

resource "aws_nat_gateway" "fatcat_nat_gateway_2" {
  allocation_id = aws_eip.fatcat_nat_eip_2.id
  subnet_id     = aws_subnet.fatcat_public_subnet_2.id
  tags = {
    Name = "fatcat_NAT_Gateway_2"
  }
}

resource "aws_eip" "fatcat_nat_eip_3" {
  depends_on = [aws_internet_gateway.igw-fatcat]
}

resource "aws_nat_gateway" "fatcat_nat_gateway_3" {
  allocation_id = aws_eip.fatcat_nat_eip_3.id
  subnet_id     = aws_subnet.fatcat_public_subnet_3.id
  tags = {
    Name = "fatcat_NAT_Gateway_3"
  }
}

# Criando fatcat Route Table para Private Subnets
resource "aws_route_table" "fatcat_private_route_1" {
  vpc_id = aws_vpc.fatcat_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.fatcat_nat_gateway_1.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

resource "aws_route_table" "fatcat_private_route_2" {
  vpc_id = aws_vpc.fatcat_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.fatcat_nat_gateway_2.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

resource "aws_route_table" "fatcat_private_route_3" {
  vpc_id = aws_vpc.fatcat_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.fatcat_nat_gateway_3.id
  }
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

# Associando Private Subnets no Private Route Table
resource "aws_route_table_association" "fatcat_private_subnet_1_association" {
  subnet_id      = aws_subnet.fatcat_private_subnet_1.id
  route_table_id = aws_route_table.fatcat_private_route_1.id
}

resource "aws_route_table_association" "fatcat_private_subnet_2_association" {
  subnet_id      = aws_subnet.fatcat_private_subnet_2.id
  route_table_id = aws_route_table.fatcat_private_route_2.id
}

resource "aws_route_table_association" "fatcat_private_subnet_3_association" {
  subnet_id      = aws_subnet.fatcat_private_subnet_3.id
  route_table_id = aws_route_table.fatcat_private_route_3.id
}

# Db Subnet Group
resource "aws_subnet" "fatcat_private_database_subnet_1" {
  vpc_id            = aws_vpc.fatcat_vpc.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "fatcat_Private_Database_Subnet_1"
  }
}

resource "aws_subnet" "fatcat_private_database_subnet_2" {
  vpc_id            = aws_vpc.fatcat_vpc.id
  cidr_block        = "10.0.8.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "fatcat_Private_Database_Subnet_2"
  }
}

resource "aws_subnet" "fatcat_private_database_subnet_3" {
  vpc_id            = aws_vpc.fatcat_vpc.id
  cidr_block        = "10.0.9.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "fatcat_Private_Database_Subnet_3"
  }
}

# Route Table Db
resource "aws_route_table" "fatcat_private_database_subnet_route" {
  vpc_id = aws_vpc.fatcat_vpc.id
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
}

# Associando Db Subnets no Db Route Table
resource "aws_route_table_association" "fatcat_private_subnet_database_association_1" {
  subnet_id      = aws_subnet.fatcat_private_database_subnet_1.id
  route_table_id = aws_route_table.fatcat_private_database_subnet_route.id
}

resource "aws_route_table_association" "fatcat_private_subnet_database_association_2" {
  subnet_id      = aws_subnet.fatcat_private_database_subnet_2.id
  route_table_id = aws_route_table.fatcat_private_database_subnet_route.id
}

resource "aws_route_table_association" "fatcat_private_subnet_database_association_3" {
  subnet_id      = aws_subnet.fatcat_private_database_subnet_3.id
  route_table_id = aws_route_table.fatcat_private_database_subnet_route.id
}