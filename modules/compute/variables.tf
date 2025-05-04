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

# In compute module variable.tf
variable "public_subnets" {
  description = "Map of public subnet IDs"
  type = map(string)
}

variable "private_subnets" {
  description = "Map of private subnet IDs"
  type = map(string)  
}


variable "app_security_groups" {
    type = list(string)
    description = "Security groups for the app instances"
}

variable "Bastion_security_groups" {
    type = list(string)
    description = "Security groups for the Bastion host"
  
}
