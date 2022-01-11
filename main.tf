resource "aws_s3_bucket" "test-bucket" {
  bucket = "my-bucket"
}


resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}