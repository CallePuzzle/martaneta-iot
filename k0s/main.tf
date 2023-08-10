terraform {
  cloud {
    organization = "martaneta"

    workspaces {
      name = "k0s"
    }
  }
}

provider "oci" {
}

module "oci-k0s" {
  source = "../../terraform-module-k0s-oci/"

  compartment_id  = "ocid1.tenancy.oc1..aaaaaaaa5ii3uidynoqhjub5ub66fm3ryn2my6txw6xrguihckyr2uyarlkq"
  k0s_config_path = "${path.root}/k0sctl.yaml"
}
