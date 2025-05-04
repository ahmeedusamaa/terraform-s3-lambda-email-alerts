variable "subnets" {
    type = list(object({
        name                 = string
        cidr_block           = string
        map_public_ip_on_launch = optional(bool)
        availability_zone    = string
    }))   
    description = "List of subnets to create"
}

variable "vpc_cidr_block" {
    type =  string
    description = "CIDR block for the VPC"
}

variable "Application_ec2" {
    type = list(object({
        name            = string
        instance_type   = string
        subnet          = string
    }))
    description = "EC2 instance configuration"
}

variable "ami_id" {
    description = "The AMI id"
    type = string
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


variable "region" {
    description = "AWS region"
    type        = string
    default   = "us-east-1"
}