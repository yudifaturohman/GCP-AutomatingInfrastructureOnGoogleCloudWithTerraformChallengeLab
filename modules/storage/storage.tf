resource "google_storage_bucket" "storage-bucket" {
  name          = "qwiklabs-gcp-01-4475560ec194"
  location      = "US"
  force_destroy = true
  uniform_bucket_level_access = true
}