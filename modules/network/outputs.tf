output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.MyVPC.id
}

output "private_subnet" {
  description = "Map of private subnet IDs"
  value = {
    for subnet_name, subnet in aws_subnet.subnets :
    subnet_name => subnet.id 
    if subnet.tags["name"] != "Public Subnet"
  }
}

output "public_subnet" {
  description = "Map of public subnet IDs"
  value = {
    for subnet_name, subnet in aws_subnet.subnets :
    subnet_name => subnet.id  
    if subnet.tags["name"] == "Public Subnet"
  }
}


output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.MyIGW.id
}

# output "nat_gateway_id" {
#   description = "The ID of the NAT Gateway"
#   value       = aws_nat_gateway.NatGW.id
# }

# output "nat_eip_id" {
#   description = "The ID of the NAT Gateway EIP"
#   value       = aws_eip.eip_nat.id
# }

output "allow_ssh_sg_id" {
  description = "Security Group ID for SSH access"
  value       = aws_security_group.Allow_SSH.id
}

output "app_sg_id" {
  description = "Security Group ID for Application EC2 instances"
  value       = aws_security_group.App_SG.id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS database"
  value       = aws_security_group.rds_sg.id
}

output "redis_sg_id" {
  description = "Security Group ID for Redis cluster"
  value       = aws_security_group.redis_sg.id
}
