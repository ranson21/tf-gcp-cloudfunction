output "id" {
  value = google_cloudfunctions_function.function.id
}

output "serverless_neg_id" {
  value = google_compute_region_network_endpoint_group.function_neg.id
}

output "cloud_function_url" {
  value       = google_cloudfunctions_function.function.https_trigger_url
  description = "The public URL of the deployed Cloud Function"
}
