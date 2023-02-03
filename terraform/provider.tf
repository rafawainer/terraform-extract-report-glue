provider "aws" {
  region = "us-east-1"
}

output "table_details" {
  value = aws_glue_catalog_table.table_name
}
