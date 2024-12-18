# Create a dedicated service account for the Cloud Function
resource "google_service_account" "function_account" {
  account_id   = "${var.name}-sa"
  display_name = "Service Account for ${var.name} Cloud Function"
}

# Grant Secret Manager Secret Accessor role at project level
resource "google_project_iam_member" "secret_access" {
  project = google_cloudfunctions_function.function.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.function_account.email}"
}

# VPC Connector for the Cloud Function
# resource "google_vpc_access_connector" "connector" {
#   name          = "${var.name}-vpc-connector"
#   ip_cidr_range = var.connector_ip_cidr_range
#   network       = var.network_name
#   region        = var.region
# }

resource "google_cloudfunctions_function" "function" {
  name        = var.name
  description = var.description
  runtime     = var.runtime

  available_memory_mb   = 128
  source_archive_bucket = var.bucket
  source_archive_object = var.path
  entry_point           = var.entrypoint

  # Use the custom service account
  service_account_email = google_service_account.function_account.email

  # dynamic "event_trigger" {
  #   for_each = var.trigger_topic == "" ? toset([]) : toset([1])
  #   content {
  #     event_type = var.trigger_type
  #     resource   = var.trigger_topic
  #   }
  # }


  trigger_http = true
  # vpc_connector    = google_vpc_access_connector.connector.id
  # ingress_settings = "ALLOW_INTERNAL_ONLY"

  environment_variables = var.env_vars
}

# IAM entry for a single user to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = var.member
}

# Create NEG for the Cloud Function
resource "google_compute_region_network_endpoint_group" "function_neg" {
  name                  = "${var.name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_function {
    function = google_cloudfunctions_function.function.name
  }
}

# Add backend service for the Cloud Function
resource "google_compute_backend_service" "function" {
  name       = "${var.name}-backend"
  protocol   = "HTTP"
  port_name  = "http"
  enable_cdn = false

  backend {
    group = google_compute_region_network_endpoint_group.function_neg.id
  }
}
