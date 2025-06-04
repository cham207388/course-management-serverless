
# DynamoDB
resource "aws_dynamodb_table" "courses" {
  name         = "CoursesTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}