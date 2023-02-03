resource "aws_glue_catalog_table" "table_name" {
  database_name = "database"
  name          = "accounts_s3"
}