variable "region" {
  default     = "us-west-2"
  type        = string
  description = "AWS region"
}

variable "key_pair" {
  type        = string
  description = "key pair for worker nodes"
}

variable "cluster_log_retention" {
  type        = number
  description = "log retention period in days"
  default     = 90
}

variable "woker_volume_size" {
  type        = number
  description = "worker node volume size in Gi"
  default     = 20
}

variable "cluster_name" {
  default     = "EKS"
  type        = string
  description = "cluster name"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "vpc cidr range"
}

variable "single_nat" {
  default     = true
  type        = bool
  description = "single cidr required?"
}

variable "public_cidrs" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "private_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
