resource "kubernetes_namespace" "notesapp" {
  metadata {
    name = "notesapp"
  }
}