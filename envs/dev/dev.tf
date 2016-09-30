module "aws_vpc" {
    source = "../../modules/aws_vpc"

    vpc_cidr_block = "10.0.1.0/24"
    name = "dev-vpc"
}
