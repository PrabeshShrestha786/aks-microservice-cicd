resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

module "rg" {
  source   = "./modules/resource_group"
  rg_name  = "rg-aks-iac-lab"
  location = "swedencentral"
}

module "network" {
  source      = "./modules/network"
  vnet_name   = "vnet-aks-iac"
  subnet_name = "snet-aks"
  rg_name     = module.rg.rg_name
  location    = module.rg.location
}

module "acr" {
  source   = "./modules/acr"
  acr_name = "acriakslab${random_string.suffix.result}"
  rg_name  = module.rg.rg_name
  location = module.rg.location
}

module "aks" {
  source     = "./modules/aks"
  aks_name   = "aks-iac-lab"
  dns_prefix = "aks-iac-lab"
  rg_name    = module.rg.rg_name
  location   = module.rg.location
  subnet_id  = module.network.subnet_id

  node_count = 1
  vm_size    = "Standard_B2s"
}