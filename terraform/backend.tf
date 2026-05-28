
terraform {

  backend "s3" {

    bucket = "aws-s3-cicd-bucket-5132"

    key = "terraform.tfstate"

    region = "us-east-1"

    dynamodb_table = "terraform-lock"

    encrypt = true
  }
}