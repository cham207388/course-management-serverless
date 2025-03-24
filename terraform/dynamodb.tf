resource "aws_dynamodb_table" "course_table" {
  name         = "Course"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name = "CourseTable"
    Env  = "dev"
  }
}