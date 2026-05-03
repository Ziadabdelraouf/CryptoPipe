terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  # This points to the file you just uploaded
  credentials = file("../creds.json")
  project     = var.project_id
  region      = "us-central1"
}

# 1. The Data Lake (Cloud Storage Bucket)
# This is where raw JSON/Parquet files will live
resource "google_storage_bucket" "data-lake-bucket" {
  name          = var.bucket_name
  location      = "US"
  force_destroy = true
  storage_class = "STANDARD"

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

# 2. The Data Warehouse (BigQuery Dataset)
# This is where your structured tables will live
resource "google_bigquery_dataset" "dataset" {
  dataset_id = "cryptopipe_raw_data"
  location   = "US"
}