resource "aws_dynamodb_table" "hama-web-Dynamo" {
  name           = "hama-web-Dynamo"
  billing_mode   = "PROVISIONED"
  hash_key       = "article_id"   # 파티션 키

  attribute {
    name = "article_id"
    type = "S"
  }

  attribute {
    name = "email"
    type = "S"
  }

  attribute {
    name = "title"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  global_secondary_index {
    hash_key        = "email"
    range_key       = "timestamp"
    name            = "UserData-email-index"
    projection_type = "ALL"
    read_capacity   = 5
    write_capacity  = 5
  }

  global_secondary_index {
    hash_key        = "title"
    name            = "simpleboard-title-index"
    projection_type = "ALL"
    read_capacity   = 1
    write_capacity  = 1
  }

  point_in_time_recovery {
    enabled = false
  }

  read_capacity  = 1
  write_capacity = 1
  stream_enabled = false
  table_class    = "STANDARD"

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity,
      tags,
      ttl
    ]
  }
}
