resource "kubernetes_config_map" "init_sql" {
  metadata {
    name      = "postgres-init-sql"
    namespace = kubernetes_namespace.notes.metadata[0].name
  }

  data = {
    "init.sql" = file("${path.module}/../app/notes-db/init.sql")
  }
}

resource "kubernetes_persistent_volume_claim" "postgres" {
  metadata {
    name      = "postgres-pvc"
    namespace = kubernetes_namespace.notes.metadata[0].name
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "db" {
  metadata {
    name      = "notes-db"
    namespace = kubernetes_namespace.notes.metadata[0].name
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "notes-db"
      }
    }
    template {
      metadata {
        labels = {
          app = "notes-db"
        }
      }
      spec {
        container {
          name  = "postgres"
          image = "postgres:16-alpine"

          env {
            name  = "POSTGRES_DB"
            value = "notes"
          }
          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "password"
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "postgres-storage"
            mount_path = "/var/lib/postgresql/data"
          }
          volume_mount {
            name       = "init-sql"
            mount_path = "/docker-entrypoint-initdb.d"
          }
        }

        volume {
          name = "postgres-storage"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres.metadata[0].name
          }
        }
        volume {
          name = "init-sql"
          config_map {
            name = kubernetes_config_map.init_sql.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "db" {
  metadata {
    name      = "notes-db"
    namespace = kubernetes_namespace.notes.metadata[0].name
  }
  spec {
    selector = {
      app = "notes-db"
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}