resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "eks" {
  source                                    = "terraform-aws-modules/eks/aws"
  cluster_name                              = var.cluster_name
  cluster_version                           = "1.19"
  subnets                                   = module.vpc.private_subnets
  cluster_endpoint_private_access           = true
  cluster_iam_role_name                     = "${var.cluster_name}-ClusterRole-${random_string.suffix.result}"
  workers_role_name                         = "${var.cluster_name}-WorkerRole-${random_string.suffix.result}"
  cluster_enabled_log_types                 = ["api","audit","authenticator","controllerManager","scheduler"]
  cluster_log_retention_in_days             = var.cluster_log_retention
  enable_irsa                               = true

  tags = {
    Cluster = var.cluster_name
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "frontend"
      instance_type                 = "t2.medium"
      asg_desired_capacity          = 1
      asg_max_size                  = 2
      asg_min_size                  = 1
      root_volume_size              = var.woker_volume_size
      root_encrypted                = true
      kubelet_extra_args            = "--node-labels=tier=frontend"
      subnets                       = module.vpc.private_subnets
      key_name                      = var.key_pair
      additional_security_group_ids = [aws_security_group.eks_worker_sg.id]
      asg_recreate_on_change        = true
    },
    {
      name                          = "backend"
      instance_type                 = "t2.medium"
      asg_desired_capacity          = 1
      asg_max_size                  = 2
      asg_min_size                  = 1
      root_volume_size              = var.woker_volume_size
      root_encrypted                = true
      kubelet_extra_args            = "--node-labels=tier=backend"
      subnets                       = module.vpc.private_subnets
      key_name                      = var.key_pair
      additional_security_group_ids = [aws_security_group.eks_worker_sg.id]
      asg_recreate_on_change        = true
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}