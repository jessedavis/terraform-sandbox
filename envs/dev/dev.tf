module "aws_vpc" {
    source = "github.com/jessedavis/terraform-sandbox/modules/aws_vpc"

    cidr_block = "10.0.1.0/24"
    name = "dev-vpc"
}
