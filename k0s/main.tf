terraform {
  cloud {
    organization = "martaneta"

    workspaces {
      name = "k0s"
    }
  }
  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "0.7.2"
    }
  }
}

provider "oci" {}

provider "sops" {}

data "sops_file" "argo" {
  source_file = "secrets.enc.yaml"
}

module "oci-k0s" {
  source = "../../terraform-module-k0s-oci/"

  compartment_id  = "ocid1.tenancy.oc1..aaaaaaaa5ii3uidynoqhjub5ub66fm3ryn2my6txw6xrguihckyr2uyarlkq"
  k0s_config_path = "${path.root}/k0sctl.yaml"

  argocd_host = "argocd-martaneta.callepuzzle.com"

  manifests_source = {
    repo_url          = "https://github.com/CallePuzzle/martaneta-iot"
    target_revision   = "HEAD"
    path              = "argo-manifests"
    directory_recurse = true
  }

  argocd_values = templatefile("${path.root}/argocd-values.yaml.tmpl", {
    argocd_host          = "argocd-martaneta.callepuzzle.com"
    github_client_id     = data.sops_file.argo.data["github.clientID"]
    github_client_secret = data.sops_file.argo.data["github.clientSecret"]
  })
}
