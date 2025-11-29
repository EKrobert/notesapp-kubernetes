resource "kubernetes_deployment" "api" {
  metadata {
    name      = "notes-api"
    namespace = kubernetes_namespace.notes.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "notes-api"
      }
    }
    template {
      metadata {
        labels = {
          app = "notes-api"
        }
      }
      spec {
        container {
          name              = "api"
          image             = "notes-api:latest"
          image_pull_policy = "Never"
          env {
            name  = "DB_HOST"
            value = "notes-db"
          }
          env {
            name  = "DB_NAME"
            value = "notes"
          }
          env {
            name  = "DB_USER"
            value = "postgres"
          }
          env {
            name  = "DB_PASSWORD"
            value = "password"
          }
          port {
            container_port = 5000
          }
        }
      }
    }
  }
  depends_on = [kubernetes_deployment.db]
}

resource "kubernetes_service" "api" {
  metadata {
    name      = "notes-api"
    namespace = kubernetes_namespace.notes.metadata[0].name
  }
  spec {
    selector = {
      app = "notes-api"
    }
    port {
      port        = 5000
      target_port = 5000
    }
  }
}