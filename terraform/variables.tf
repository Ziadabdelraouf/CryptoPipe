variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "cryptopipe-project"
}

variable "bucket_name" {
  description = "The GCS bucket name for raw crypto exports"
  type        = string
  default     = "cryptopipe-data-lake-cryptopipe-project"
}