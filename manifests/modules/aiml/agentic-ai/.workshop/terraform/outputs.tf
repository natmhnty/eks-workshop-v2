output "environment_variables" {
  description = "Environment variables to be added to the IDE shell"
  value = {
    BEDROCK_MODEL_ID = "anthropic.claude-3-7-sonnet-20250219-v1:0"
    CATALOG_URL = "http://catalog-svc.catalog.svc.cluster.local:80"
  }
}