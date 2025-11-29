resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "notes-frontend"
    namespace = kubernetes_namespace.notes.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "notes-frontend"
      }
    }
    template {
      metadata {
        labels = {
          app = "notes-frontend"
        }
      }
      spec {
        container {
          name              = "frontend"
          image             = "notes-frontend:latest"
          image_pull_policy = "Never"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "notes-frontend"
    namespace = kubernetes_namespace.notes.metadata[0].name
  }
  spec {
    selector = {
      app = "notes-frontend"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}