# This TF file was extracted from the existing cluster
# with `terraform import` command
# and manually edited.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "account_id" { }
variable "region" { }

provider "aws" {
  region = var.region
}

locals {
  # cluster size
  cluster_size    = 5

  # don't touch it
  cluster_name    = "tf-controller"
  node_group_name = "ng-cc5a1ac4"
}

# aws_eks_node_group.ng-cc5a1ac4:
resource "aws_eks_node_group" "ng-cc5a1ac4" {
    cluster_name    = local.cluster_name
    node_group_name = local.node_group_name

    version         = "1.21"
    scaling_config {
        desired_size = local.cluster_size
        max_size     = local.cluster_size
        min_size     = local.cluster_size
    }

    ami_type        = "AL2_x86_64"
    capacity_type   = "ON_DEMAND"
    disk_size       = 0
    instance_types  = [
        "m5.large",
    ]

    labels          = {
        "alpha.eksctl.io/cluster-name"   = local.cluster_name
        "alpha.eksctl.io/nodegroup-name" = local.node_group_name
    }
    node_role_arn   = "arn:aws:iam::${var.account_id}:role/eksctl-tf-controller-nodegroup-ng-NodeInstanceRole-KTZC6GLD9NTW"
    release_version = "1.21.5-20220112"
    subnet_ids      = [
        "subnet-02cd58b8a7095c3c7",
        "subnet-070f5075410d2b01c",
        "subnet-07fcebbc4469f85b4",
    ]
    tags            = {
        "alpha.eksctl.io/cluster-name"                = local.cluster_name
        "alpha.eksctl.io/eksctl-version"              = "0.79.0"
        "alpha.eksctl.io/nodegroup-name"              = local.node_group_name
        "alpha.eksctl.io/nodegroup-type"              = "managed"
        "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = local.cluster_name
    }
    tags_all        = {
        "alpha.eksctl.io/cluster-name"                = local.cluster_name
        "alpha.eksctl.io/eksctl-version"              = "0.79.0"
        "alpha.eksctl.io/nodegroup-name"              = local.node_group_name
        "alpha.eksctl.io/nodegroup-type"              = "managed"
        "eksctl.cluster.k8s.io/v1alpha1/cluster-name" = local.cluster_name
    }

    launch_template {
        name    = "eksctl-tf-controller-nodegroup-${local.node_group_name}"
        version = "1"
    }

    update_config {
        max_unavailable = 1
    }
}
