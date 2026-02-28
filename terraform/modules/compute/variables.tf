variable "project_name" {
  description = "Project name"
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "jenkins_sg_id" {
  description = "Jenkins security group ID"
  type        = string
}

variable "k8s_master_sg_id" {
  description = "K8s master security group ID"
  type        = string
}

variable "k8s_worker_sg_id" {
  description = "K8s worker security group ID"
  type        = string
}

variable "jenkins_instance_type" {
  description = "Jenkins instance type"
  type        = string
}

variable "k8s_master_instance_type" {
  description = "K8s master instance type"
  type        = string
}

variable "k8s_worker_instance_type" {
  description = "K8s worker instance type"
  type        = string
}

variable "k8s_worker_count" {
  description = "Number of K8s worker nodes"
  type        = number
}