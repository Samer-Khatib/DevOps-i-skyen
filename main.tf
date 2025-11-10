terraform {
  backend "s3" {
    bucket         = "pgr301-terraform-state"
    key            = "terraform/state.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "terraform-locks" # remove this line if you didn’t create the table
  }
}
