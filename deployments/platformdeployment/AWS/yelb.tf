module "yelb" {
  source = "./modules/yelb/"

  # Change deployment environment by modifying this
  # parameter for either 'aws.private' or 'aws.public'
  # you'll need to enter all proper parameters in
  providers {
    aws="aws.private"
  }

  ### General Variables
  db_class = "db.m4.large"

  ### Symphony vars
  db_version = "9.6.00"
  
  ### AWS vars
  #db_version = "9.6.1"
}