variable "minikube_ip" {
  description = "Minikube IP address"
  type        = string
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "notes" {
  metadata {
    name = "notes-app"
  }
}