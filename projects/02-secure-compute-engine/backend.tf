terraform {
  backend "gcs" {
    bucket = "gcp-portfolio-tfstate-usc1-7f4e9a2c"
    prefix = "labs/02-secure-compute-engine"
  }
}
