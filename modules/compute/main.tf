# This file contains the main configuration for the compute module.
# It defines the resources needed for the compute module, including EC2 instances
# It also includes the data source for the Amazon Linux AMI.

# key pair
resource "tls_private_key" "rsa-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "sshkeypair" {
  key_name   = "SSH-key"
  public_key = tls_private_key.rsa-key.public_key_openssh
}

resource "local_file" "ssh-key" {
  content         = tls_private_key.rsa-key.private_key_pem
  filename        = "ssh-key-pair.pem"
  file_permission = "0600"
}


# Data source for the Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



# EC2 instance for the application
resource "aws_instance" "Application" {
  for_each = { for app in var.Application_ec2 : app.name => app }
  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.value.instance_type
  subnet_id     = var.private_subnets[each.value.subnet]
  vpc_security_group_ids = var.app_security_groups
  key_name      = aws_key_pair.sshkeypair.key_name
  tags = {
    Name = each.value.name
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip.txt"
  }
}

# EC2 instance for the Bastion host
resource "aws_instance" "Bastion" {
  ami             = "ami-084568db4383264d4"
  instance_type   = "t2.micro"
  subnet_id       = var.public_subnets["Public Subnet"]
  vpc_security_group_ids = var.Bastion_security_groups
  key_name        = aws_key_pair.sshkeypair.key_name
  tags = {
    Name = "Bastion"
  }
}










resource "aws_ses_email_identity" "email_identity" {
  email = "ahmedosama21049@gmail.com"
}

resource "aws_iam_role" "lambda_iam" {
  name = "lambda_execution_role_minimal"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "revoke_keys_role_policy" {
  name = "revoke_keys_role_policy"
  role = aws_iam_role.lambda_iam.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "ses:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

data "archive_file" "zip_the_python_code" {
type        = "zip"
source_file  = "./modules/compute/python/lambda_handler.py"
output_path = "./modules/compute/python/lambda_function.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename      = data.archive_file.zip_the_python_code.output_path
  function_name = "Test_Lambda_Function"
  role          = aws_iam_role.lambda_iam.arn
  handler       = "lambda_handler.lambda_handler"  
  runtime       = "python3.8"
}


resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = "bucket-terraform-state-0"
  lambda_function {
    lambda_function_arn = aws_lambda_function.terraform_lambda_func.arn
    events              = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]

  }
}

resource "aws_lambda_permission" "AllowS3Invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda_func.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::bucket-terraform-state-0" 
}