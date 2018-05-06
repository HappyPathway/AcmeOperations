
module "production_network" {
  source = "git@github.com:HappyPathway/AzureNetworkGroup.git"
  resource_group = "acme-production"
}

module "production_consul" {
  source = "git@github.com:HappyPathway/AzureConsulCluster.git"
  resource_group = "${module.production_network.resource_group}"
  consul_cluster = "production"
  subnet_id = "${module.production_network.subnet_id}"
  azure_subscription = "${var.azure_subscription}"
  azure_tenant = "${var.azure_tenant}"
  azure_client = "${var.azure_client}"
  azure_secret = "${var.azure_secret}"
  system_user = "${var.system_user}"
  system_password = "${var.system_password}"
}
