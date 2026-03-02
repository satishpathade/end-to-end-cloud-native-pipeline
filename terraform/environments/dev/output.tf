output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${module.compute.jenkins_public_ip}:8080"
}

output "jenkins_ssh" {
  description = "SSH command for Jenkins"
  value       = "ssh -i ~/Downloads/end-to-end-CICD.pem ubuntu@${module.compute.jenkins_public_ip}"
}

output "k8s_master_ssh" {
  description = "SSH command for K8s master"
  value       = "ssh -i ~/Downloads/end-to-end-CICD.pem ubuntu@${module.compute.k8s_master_public_ip}"
}

output "k8s_worker_ssh" {
  description = "SSH commands for K8s workers"
  value       = [for ip in module.compute.k8s_worker_public_ips : "ssh -i ~/Downloads/end-to-end-CICD.pem ubuntu@${ip}"]
}

output "infrastructure_info" {
  description = "Complete infrastructure information"
  value = {
    jenkins = {
      public_ip  = module.compute.jenkins_public_ip
      private_ip = module.compute.jenkins_private_ip
      url        = "http://${module.compute.jenkins_public_ip}:8080"
    }
    kubernetes = {
      master = {
        public_ip  = module.compute.k8s_master_public_ip
        private_ip = module.compute.k8s_master_private_ip
      }
      workers = {
        public_ips  = module.compute.k8s_worker_public_ips
        private_ips = module.compute.k8s_worker_private_ips
      }
    }
  }
}

