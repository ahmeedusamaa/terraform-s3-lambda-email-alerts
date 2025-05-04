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

variable "region" {
    description = "AWS region"
    type        = string
    default   = "us-east-1"
}