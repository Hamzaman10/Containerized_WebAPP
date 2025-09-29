variable "default_tags" {
  type = map(string)
  default = {
    Project     = "Assignment1"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

output "default_tags" {
  value = var.default_tags
}
