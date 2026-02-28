variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "End-to-End CICD Pipeline"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/20"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "end-to-end-CICD"
}

variable "jenkins_instance_type" {
  description = "Instance type for pipeline server (Jenkins)"
  type        = string
  default     = "t3.small"
}

variable "k8s_master_instance_type" {
  description = "Instance type for K8s master"
  type        = string
  default     = "t3.small"
}

variable "k8s_worker_instance_type" {
  description = "Instance type for K8s workers"
  type        = string
  default     = "t3.micro"
}

variable "k8s_worker_count" {
  description = "Number of K8s worker nodes"
  type        = number
  default     = 2
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"] 
}