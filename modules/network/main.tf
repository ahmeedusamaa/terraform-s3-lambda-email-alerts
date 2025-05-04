# This file contains the main configuration for the network module.
# It defines the resources needed for the network module, including VPC, subnets,
# route tables, and internet gateway.
# It also includes the NAT gateway and EIP for the private subnets.


# VPC configuration
resource "aws_vpc" "MyVPC" {
  cidr_block         =  var.vpc_cidr_block
  enable_dns_support = true
  tags = {
    Name = "MyVPC"
  }
}



# VPC configuration
resource "aws_vpc" "VPCtoTest" {
  cidr_block         =  "10.2.0.0/16"
  enable_dns_support = true
  tags = {
    Name = "MyVPC"
  }
}








# Subnet configuration
resource "aws_subnet" "subnets" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }
  vpc_id = aws_vpc.MyVPC.id
  cidr_block = each.value.cidr_block
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  availability_zone = each.value.availability_zone
  tags = {
    name = each.value.name
  }
}

# Internet Gateway configuration
resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
    Name = "MyIGW"
  }
}

# Route Table configuration
resource "aws_route_table" "PubRtb" {
  vpc_id = aws_vpc.MyVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
  }
  tags = {
    Name = "PubRtb"
  }
}
resource "aws_route_table" "PrvRtb" {
  vpc_id = aws_vpc.MyVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
    # gateway_id = aws_nat_gateway.NatGW.id
  }
  tags = {
    Name = "PrvRtb"
  }
}

resource "aws_route_table_association" "PubAssoc" {
  subnet_id      = aws_subnet.subnets["Public Subnet"].id
  route_table_id = aws_route_table.PubRtb.id
}
resource "aws_route_table_association" "PrvAssoc" {
  for_each = { for subnet in var.subnets : subnet.name =>  subnet if subnet.name != "Public Subnet" }
  subnet_id      = aws_subnet.subnets[each.value.name].id
  route_table_id = aws_route_table.PrvRtb.id
}


# NAT Gateway configuration
# resource "aws_eip" "eip_nat" {
#   domain = "vpc"
#   tags = {
#     Name = "EIP-NAT"
#   }
# }

# resource "aws_nat_gateway" "NatGW" {
#   allocation_id = aws_eip.eip_nat.id
#   subnet_id     = aws_subnet.PubSubnet.id
#   tags = {
#     Name = "NatGW"
#   }
# }

#Security Group configuration
resource "aws_security_group" "Allow_SSH" {
  vpc_id = aws_vpc.MyVPC.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow_SSH"
  }
}
resource "aws_security_group" "App_SG" {
  vpc_id = aws_vpc.MyVPC.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.MyVPC.cidr_block]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.MyVPC.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "App_SG"
  }
}

resource "aws_security_group" "rds_sg" {
    vpc_id = aws_vpc.MyVPC.id
  name        = "rds-sg"
  description = "Security group for RDS instance"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 3306  
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.Allow_SSH.id] 
  }

  tags = {
    Name = "RDS Security Group"
  }
}

resource "aws_security_group" "redis_sg" {
  vpc_id = aws_vpc.MyVPC.id

  name        = "redis-security-group"
  description = "Security group for Redis cluster"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [aws_security_group.Allow_SSH.id] 
  }
}

