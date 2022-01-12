module "s3_test" {
  source = "../"

  bucket = {
    name = "test-bucket"
  }

  kms = {
    admins = [
      "*"
    ]
    access = [
      "*"
    ]
  }
}