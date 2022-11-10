provider "aws" {
    region = "us-west-2"
    access_key = "AKIA4OBQZA63ILY4HAU5"
    secret_key = "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"
}
resource "aws_vpc" "VPC2" {
    cidr_block = var.vpccidr
    tags ={
    Name = "VPC2"
    }
}
resource "aws_subnet" "pubsubnet" {
    vpc_id = aws_vpc.VPC2.id
    cidr_block = var.subnetcidr
    tags ={
        Name = "pubsubnet"
    }
    }
resource "aws_internet_gateway" "internetgateway" {
  vpc_id = aws_vpc.VPC2.id
  tags = {
    Name = "internetgateway"
  }
  }
resource "aws_route_table" "routetable" {
    vpc_id = aws_vpc.VPC2.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internetgateway.id 
    }
    tags = {
        name = "routetable"
    }
}
resource "aws_network_interface" "networkinterface" {
    subnet_id = aws_subnet.pubsubnet.id
    security_groups = [aws_security_group.sg1.id]
    attachment {
    instance     = aws_instance.ec2.id
    device_index = 1
  }
    tags = {
        Name = "networkinterface"
    }
}
resource "aws_security_group" "sg1" {
    name = "sg1"
    vpc_id = aws_vpc.VPC2.id
    ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    egress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    egress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg1"
    }
}
resource "aws_instance" "ec2" {
    ami = "ami-0d593311db5abb72b"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    key_name = "lock2"
    vpc_security_group_ids = [aws_security_group.sg1.id]
    subnet_id = aws_subnet.pubsubnet.id
    tags = {
        Name = "ec2"
    }
}
