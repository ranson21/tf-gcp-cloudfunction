resource "google_storage_bucket_object" "source" {
  name   = "index.zip"
  bucket = var.bucket
  source = var.path
}

resource "google_cloudfunctions_function" "function" {
  name        = var.name
  description = var.description
  runtime     = var.runtime

  available_memory_mb   = 128
  source_archive_bucket = var.bucket
  source_archive_object = google_storage_bucket_object.source.name
  entry_point           = var.entrypoint

  dynamic "event_trigger" {
    for_each = var.trigger_topic == "" ? toset([]) : toset([1])
    content {
      event_type = var.trigger_type
      resource   = var.trigger_topic
    }
  }

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

