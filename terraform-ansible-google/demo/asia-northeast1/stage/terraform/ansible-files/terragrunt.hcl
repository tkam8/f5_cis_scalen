# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------


# Use below code as backup to dependency block as last resort
// data "terraform_remote_state" "vpc" {
//     backend = "gcs"
//   config = {
//     bucket         = "tky-drone-demo-stage"
//     prefix         = "terraform/state"
//     region         = "asia-northeast1"
//   }
// }

terraform {
  source = "github.com/tkam8/f5_cis_scalen_modules//ansible_files?ref=v0.1"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = "../../../../terragrunt.hcl"
}

dependency "gke1" {
  config_path = "../functions/gke_cluster1"

  mock_outputs = {
    gke1_cluster_name    = "clusterName1"
    gke1_endpoint        = "3.3.3.3"
    #cluster1_username    = "admin"
    #cluster1_password    = "default"
  }
}

dependency "gke2" {
  config_path = "../functions/gke_cluster2"

  mock_outputs = {
    gke2_cluster_name    = "clusterName2"
    gke2_endpoint        = "3.3.3.4"
    #cluster2_username    = "admin"
    #cluster2_password    = "default"
  }
}

dependency "gke3" {
  config_path = "../functions/gke_cluster3"

  mock_outputs = {
    gke3_cluster_name    = "clusterName3"
    gke3_endpoint        = "3.3.3.5"
    #cluster3_username    = "admin"
    #cluster3_password    = "default"
  }
}

dependency "bigip1" {
  config_path = "../functions/bip1"

  mock_outputs = {
    bigip1_public_ip    = "1.1.1.1"
    bigip1_private_ip   = "2.2.2.2"
  }
}

dependency "bigip2" {
  config_path = "../functions/bip2"

  mock_outputs = {
    bigip2_public_ip    = "1.1.1.2"
    bigip2_private_ip   = "2.2.2.3"
  }
}

dependency "bigip3" {
  config_path = "../functions/bip3"

  mock_outputs = {
    bigip3_public_ip    = "1.1.1.3"
    bigip3_private_ip   = "2.2.2.4"
  }
}


# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  terragrunt_path              = "${get_terragrunt_dir()}"
  app_tag_value                = "terrycisscalen"
  gke1_cluster_name            = dependency.gke1.outputs.gke_cluster_name
  gke2_cluster_name            = dependency.gke2.outputs.gke_cluster_name
  gke3_cluster_name            = dependency.gke3.outputs.gke_cluster_name
  gke1_endpoint                = dependency.gke1.outputs.gke_endpoint
  gke2_endpoint                = dependency.gke2.outputs.gke_endpoint
  gke3_endpoint                = dependency.gke3.outputs.gke_endpoint
  // cluster1_username            = dependency.gke1.outputs.cluster_username
  // cluster2_username            = dependency.gke2.outputs.cluster_username
  // cluster3_username            = dependency.gke3.outputs.cluster_username
  // cluster1_password            = dependency.gke1.outputs.cluster_password
  // cluster2_password            = dependency.gke2.outputs.cluster_password
  // cluster3_password            = dependency.gke3.outputs.cluster_password
  bigip1_public_ip             = dependency.bigip1.outputs.f5_public_ip
  bigip2_public_ip             = dependency.bigip2.outputs.f5_public_ip
  bigip3_public_ip             = dependency.bigip3.outputs.f5_public_ip
  bigip1_private_ip            = dependency.bigip1.outputs.f5_private_ip
  bigip2_private_ip            = dependency.bigip2.outputs.f5_private_ip
  bigip3_private_ip            = dependency.bigip3.outputs.f5_private_ip
}
