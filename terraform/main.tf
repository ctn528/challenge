variable gcp_json_auth {}
variable gcp_project {}
variable gcp_region {}
variable k8s_name {}

provider "google" {
  credentials = file(var.gcp_json_auth)
  project     = var.gcp_project
  region      = var.gcp_region
}

provider "kubernetes" {
  load_config_file = "false"

  host     = data.google_container_cluster.gcp_kubernetes.endpoint
  username = google_container_cluster.gcp_kubernetes.master_auth[0].username
  password = google_container_cluster.gcp_kubernetes.master_auth[0].password
  cluster_ca_certificate = base64decode(google_container_cluster.gcp_kubernetes.master_auth[0].cluster_ca_certificate)
  client_certificate = base64decode(google_container_cluster.gcp_kubernetes.master_auth[0].client_certificate)
  client_key = base64decode(google_container_cluster.gcp_kubernetes.master_auth[0].client_key)
}

resource "random_string" "random" {
  length = 16
  special = true
  override_special = ":?-"
}

resource "google_container_cluster" "gcp_kubernetes" {
  name     = var.k8s_name
  location = "us-central1-a"
  remove_default_node_pool = false
  initial_node_count       = 1

  master_auth {
    username = "k8sadmin2020"
    password = random_string.random.result

    client_certificate_config {
      issue_client_certificate = false
    }
  }
  node_config {
    machine_type = "e2-small"
  }
}

data "google_container_cluster" "gcp_kubernetes" {
  name     = google_container_cluster.gcp_kubernetes.name
  location = google_container_cluster.gcp_kubernetes.location
}

resource "kubernetes_deployment" "app1" {
  metadata {
    name = "app1"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "app1"
      }
    }

    template {
      metadata {
        labels = {
          app = "app1"
        }
      }

      spec {
        container {
          name  = "app1"
          image = "gcr.io/everis-287923/imagen-python:v2"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app1" {
  metadata {
    name = "svcapp1"
  }

  spec {
    selector = {
      app = "app1"
    }

    port {
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

    type = "NodePort"
  }
}


resource "kubernetes_ingress" "ingress" {
  metadata {
    name = "ingress01"
  }

  spec {
    backend {
      service_name = "svcapp1"
      service_port = 5000
    }

    #rule {
    #  http {
    #    path {
    #      path = "/greetings"
    #      backend {
    #        service_name = "app1"
    #        service_port = 5000
    #      }
    #    }
    #  }
   # }
  }
}


output "gke_name" {
  value = google_container_cluster.gcp_kubernetes.name
}
output "docker_image" {
  value = kubernetes_deployment.app1.spec[0].template[0].spec[0].container[0].image
}
