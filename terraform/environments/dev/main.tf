# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  project_name         = var.project_name
  vpc_cidr            = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# Security Module
module "security" {
  source = "../../modules/security"

  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  vpc_cidr         = module.vpc.vpc_cidr
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# Compute Module
module "compute" {
  source = "../../modules/compute"

  project_name              = var.project_name
  key_name                  = var.key_name
  public_subnet_ids         = module.vpc.public_subnet_ids
  jenkins_sg_id            = module.security.jenkins_sg_id
  k8s_master_sg_id         = module.security.k8s_master_sg_id
  k8s_worker_sg_id         = module.security.k8s_worker_sg_id
  jenkins_instance_type     = var.jenkins_instance_type
  k8s_master_instance_type  = var.k8s_master_instance_type
  k8s_worker_instance_type  = var.k8s_worker_instance_type
  k8s_worker_count         = var.k8s_worker_count
}
