subnets = [ 
    {
        name                 = "Public Subnet"
        cidr_block           = "10.0.1.0/24"
        map_public_ip_on_launch = true
        availability_zone    = "us-east-1a"
    },
    {
        name                 = "Private Subnet 1"
        cidr_block           = "10.0.2.0/24"
        availability_zone    = "us-east-1a"
    },
        {
        name                 = "Private Subnet 2"
        cidr_block           = "10.0.3.0/24"
        availability_zone    = "us-east-1b"
    }
]

vpc_cidr_block = "10.0.0.0/16"

ami_id = "ami-084568db4383264d4"

region = "us-east-1"

Application_ec2 = [
    {
        name = "App-Instance"
        instance_type   = "t2.micro"
        subnet          = "Private Subnet 1" 
    }
]

rds_instance = {
    allocated_storage = 20
    engine           = "mysql"
    instance_type    = "db.t3.micro"
    db_name          = "mydb"
    username         = "admin"
    password         = "password"
    subnet           = "Private Subnet"
    name             = "RDS-Instance"
}