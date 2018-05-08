variable "key_name" {
  default = "id_rsa"
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "github.com/HappyPathway/VPC"
}

module "public_subnet" {
  source            = "git@github.com:HappyPathway/TerraformModules//PublicSubnet"
  subnet_name       = "consul-public"
  vpc_id            = "${module.vpc.vpc_id}"
  route_table_id    = "${module.vpc.route_table_id}"
  availability_zone = "us-east-1a"
}

module "private_subnet" {
  source            = "git@github.com:HappyPathway/PrivateSubnet"
  subnet_name       = "consul-private"
  vpc_id            = "${module.vpc.vpc_id}"
  public_subnet_id  = "${module.public_subnet.subnet_id}"
  availability_zone = "us-east-1a"
}

module "bastion" {
  source            = "git@github.com:HappyPathway/TerraformModules//BastionHost"
  public_subnet_id  = "${module.public_subnet.subnet_id}"
  private_subnet_id = "${module.private_subnet.subnet_id}"
  vpc_id            = "${module.vpc.vpc_id}"
  ssh_access        = "0.0.0.0/0"
  key_name          = "${var.key_name}"
}

module "consulCluster" {
  source 	      = "git@github.com:HappyPathway/TerraformModules//ConsulCluster"
  key_name            = "${var.key_name}"
  service_port        = 8500
  service_healthcheck = "/ui"
  instance_type       = "m4.large"
  cluster             = "dc1"
  domain              = "happypathway.com"
  public_subnet_id    = "${module.public_subnet.subnet_id}"
  private_subnet_id   = "${module.private_subnet.subnet_id}"
  vpc_id              = "${module.vpc.vpc_id}"
  enable_ssl          = false
  set_dns             = false
}
