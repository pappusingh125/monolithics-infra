locals {
  environment = "qa"
  default_tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
    Project     = "PPS-Monolithics"
    Tier        = "QualityAssurance"
    CreatedAt   = "2026-10-15"
  }
  common_tags = merge(local.default_tags, var.tags)
}
