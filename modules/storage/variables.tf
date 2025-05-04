variable "redis_security_group" {
  description = "Security group for Redis"
  type        = string
}

variable "public_subnets" {
  description = "Map of public subnet IDs"
  type = map(string)
}

variable "private_subnets" {
  description = "Map of private subnet IDs"
  type = map(string)  
}

variable "rds_instance" {
    description = "RDS instance configuration"
    type = object({
        allocated_storage = number
        engine           = string
        instance_type    = string
        db_name          = string
        username         = string
        password         = string
        subnet           = string
        name             = string
    })
}

variable "rds_security_group" {
  description = "Security group for RDS"
  type        = string
}

variable "redis_subnet_group" {
  description = "Subnet group for Redis"
  type        = string
}

