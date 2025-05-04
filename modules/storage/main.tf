# this file defines the resources needed for the storage module, including
# Elasticache and RDS instances.

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name        = "elasticache-subnet-group"
  subnet_ids  = [
    var.private_subnets["Private Subnet 1"],
    var.private_subnets["Private Subnet 2"]
  ]
  tags = {
    Name = "elasticache Subnet Group"
  }
}


resource "aws_elasticache_cluster" "pte-dev-redis" {
  cluster_id           = "pte-dev"
  engine               = "redis"
  node_type            = "cache.t3.micro"  # Choose a suitable instance type based on your needs
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"  # Using Redis 7.0 parameter group
  engine_version       = "7.0"             # Specify the Redis engine version
  apply_immediately    = true
  port                 = 6379
  security_group_ids   = [var.redis_security_group]
  subnet_group_name    = aws_elasticache_subnet_group.elasticache_subnet_group.name
  tags = {
    Name = "pte-dev-redis"
  }
}


resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group"
  subnet_ids  = [
    var.private_subnets["Private Subnet 1"],
    var.private_subnets["Private Subnet 2"]
  ]
  tags = {
    Name = "RDS Subnet Group"
  }
}


resource "aws_db_instance" "rds_instance" {
  allocated_storage  = var.rds_instance.allocated_storage
  storage_type      = "gp2"
  engine             = var.rds_instance.engine
  instance_class     = var.rds_instance.instance_type
  username           = var.rds_instance.username
  password           = var.rds_instance.password
  parameter_group_name = "default.mysql8.0"
  publicly_accessible    = false

  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [var.rds_security_group]
  skip_final_snapshot = true

  tags = {
    Name = var.rds_instance.name 
  }
}
