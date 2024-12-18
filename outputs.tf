output "id" {
  value = google_cloudfunctions_function.function.id
}

output "serverless_neg_id" {
  value = google_compute_region_network_endpoint_group.function_neg.id
}
