terraform {
  backend "s3" {
    profile        = "mm-stage"
    bucket         = "mm-stg-initial-bucket"
    region         = "eu-west-1"
    key            = "mm/intuitive/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "mm-stg-dynamodb-state-locks-eu-west-1"
  }
}