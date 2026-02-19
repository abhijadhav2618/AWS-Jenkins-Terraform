variable "vpc_name" {}
variable "vpc_cidr" {}
variable "cidr_public_subnets" {}
variable "cidr_private_subnets" {}
variable "availability_zones" {}
variable "project_name" {}

output "dev-project-abhi-vpc-id" {
    value = aws_vpc.my_vpc.id
}

#VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = var.vpc_name
    }
}

#Public Subnet
resource "aws_subnet" "public_subnet" {
    count = length(var.cidr_public_subnets)
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = element(var.cidr_public_subnets, count.index)
    availability_zone = element(var.availability_zones, count.index)
    tags = {
        Name = "${var.project_name}-public-subnet-${count.index+1}"
    }
}

#Private Subnet
resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    count = length(var.cidr_private_subnets)
    cidr_block = element(var.cidr_private_subnets, count.index)
    availability_zone = element(var.availability_zones, count.index)
    tags = {
        Name = "${var.project_name}-private-subent-${count.index+1}"
    }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${var.project_name}-public-igw"
    }
}

#Public RT
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "${var.project_name}-public-RT"
    }
}

#Public RT Association
resource "aws_route_table_association" "public_rt_association" {
    route_table_id = aws_route_table.public_rt.id
    count = length(aws_subnet.public_subnet)
    subnet_id = aws_subnet.public_subnet[count.index].id
}

#Private RT
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.my_vpc.id
    tags = {
        Name = "${var.project_name}-private-RT"
    }
}

#Private RT Association
resource "aws_route_table_association" "private_rt_association" {
    route_table_id = aws_route_table.private_rt.id
    count = length(aws_subnet.private_subnet)
    subnet_id = aws_subnet.private_subnet[count.index].id
}