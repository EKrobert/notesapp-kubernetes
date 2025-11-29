resource "kubernetes_ingress_v1" "notes" {
  metadata {
    name      = "notes-ingress"
    namespace = kubernetes_namespace.notes.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "false"
      "nginx.ingress.kubernetes.io/use-regex"          = "true"
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/$2"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      host = "notes.${var.minikube_ip}.nip.io"

      http {
        path {
          path      = "/api(/|$)(.*)"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service.api.metadata[0].name
              port {
                number = 5000
              }
            }
          }
        }

        path {
          path      = "/()(.*)"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service.frontend.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}