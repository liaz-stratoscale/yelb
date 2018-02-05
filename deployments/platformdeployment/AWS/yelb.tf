module "yelb" {
  source = "./modules/yelb/"
  providers {
    aws="aws.public"
  }
  ### Private vars
  # db_class = "m4.large"
  # db_version = "9.6.00"
  
  ### AWS vars
  db_class = "db.m4.large"
  db_version = "9.6.1"

}
