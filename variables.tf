variable "name" {
  type        = string
  description = "Name of the function"
}

# variable "network_name" {
#   description = "The name of the VPC network"
#   type        = string
# }

variable "region" {
  description = "The region to deploy the Cloud Function"
  type        = string
}

variable "connector_ip_cidr_range" {
  description = "The IP CIDR range for the VPC connector"
  type        = string
  default     = "10.8.0.0/28"
}

variable "description" {
  type        = string
  description = "Description of the function"
}

variable "runtime" {
  type        = string
  description = "Runtime for the function (i.e. 'nodejs16', 'python39', 'dotnet3', 'go116', 'java11', 'ruby30', 'php74')"
}

variable "bucket" {
  type        = string
  description = "Bucket storing the source code for the function"
}

variable "path" {
  type        = string
  description = "Path to the source archive in the storage bucket"
}

variable "entrypoint" {
  type        = string
  description = "Entrypoint to the function"
}

variable "member" {
  type        = string
  description = "Member or members (allUsers) with permission to invoke this function"
  default     = "allUsers"
}


variable "env_vars" {
  type        = map(any)
  description = "Map of environment variables for the function"
  default     = {}
}

variable "trigger_topic" {
  type        = string
  description = "Pub/Sub topic to trigger the cloud function"
  default     = ""
}

variable "trigger_type" {
  type        = string
  description = "Type of event that will trigger the function"
  default     = ""
}
