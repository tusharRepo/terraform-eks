output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "kubectl_config" {
  description = "kubectl config as generated by the module."
  value       = module.eks.kubeconfig
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.config_map_aws_auth
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = var.cluster_name
}

output "private_route_table_ids" {
    description = "Private route table IDs"
    value       = module.vpc.private_route_table_ids
}

output "public_route_table_ids" {
    description = "Public route table IDs"
    value       = module.vpc.public_route_table_ids
}

output "private_subnets" {
    description = "Private subnets ids"
    value       = module.vpc.private_subnets
}

output "public_subnets" {
    description = "Private subnets ids"
    value       = module.vpc.public_subnets
}

output "vpc_id" {
    description = "vpc id"
    value       = module.vpc.vpc_id
}

output "bastion_host_instance" {
    description = "bastion host"
    value       = aws_instance.bastion.public_ip
}

output "bastion_host_sg" {
    description = "bastio host security group"
    value       = aws_security_group.eks_bastion_sg.id
}

