provider "aws" {

}

terraform {
  backend "s3" {
    bucket = "terraform-states-327498361889"
    key    = "live-orders/terraform.tfstate"
    region = "us-east-1"
    #    dynamodb_table = "terraform-lock-table"
    #    encrypt        = true
  }
}