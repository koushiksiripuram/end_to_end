
terraform {

  backend "s3" {

    bucket = "amzs3-dem-bucketcicd"

    key = "terraform.tfstate"

    region = "ap-south-1"

    dynamodb_table = "terraform-lock"

    encrypt = true
  }
}