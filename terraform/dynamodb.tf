resource "aws_dynamodb_table" "dynamodb-table-users" {
  name           = "Users"
  hash_key       = "unique_id"
  stream_enabled = false
  billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "unique_id"
    type = "S"
  }
}
