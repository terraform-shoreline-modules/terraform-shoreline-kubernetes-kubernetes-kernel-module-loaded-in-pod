terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "kubernetes_kernel_module_loaded_in_pod" {
  source    = "./modules/kubernetes_kernel_module_loaded_in_pod"

  providers = {
    shoreline = shoreline
  }
}