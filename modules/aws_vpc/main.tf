module "aws_vpc" {
    cidr_block = "${var.vpc_cidr_block}"
    enable_dns_hostnames = true

    tags {
        Name = "${var.name}"
        terraform = "true"
    }
}
