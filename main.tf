resource "aws_s3_bucket" "test-bucket" {
  bucket = "tjfexamplehk23525252352"

  tags = {
    Name        = "My test bucket"
    Environment = "env"
  }
}