module "VPC" {
    source = "./Networking"
    vpc_name = var.vpc_name
    vpc_cidr = var.vpc_cidr
    cidr_public_subnets = var.public_subnet_cidr
    cidr_private_subnets = var.private_subnet_cidr
    availability_zones = var.availability_zones
    project_name = var.project_name
}