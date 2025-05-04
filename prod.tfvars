subnets = [ 
    {
        name                 = "Public Subnet"
        cidr_block           = "10.1.1.0/24"
        map_public_ip_on_launch = true
        availability_zone    = "us-east-1a"
    },
    {
        name                 = "Private Subnet"
        cidr_block           = "10.1.2.0/24"
        availability_zone    = "us-east-1a"
    }
]

vpc_cidr_block = "10.1.0.0/16"

ami_id = "ami-084568db4383264d4"

region = "us-central-1"

Application_ec2 = [
    {
        name = "App-Instance"
        instance_type   = "t2.micro"
        subnet          = "Private Subnet" 
    }
]

rds_instance = {
    tags = {
        Name = "RDS-Instance"
    }
    allocated_storage = 20
    engine           = "mysql"
    instance_type    = "db.t2.micro"
    db_name          = "mydb"
    username         = "admin"
    password         = "password"
    subnet           = "Private Subnet"
}