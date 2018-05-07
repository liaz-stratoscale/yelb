module "yelb" {
  source = "./modules/yelb/"

  # Change deployment environment by modifying this
  # parameter for either 'aws.private' or 'aws.public'
  # you'll need to enter all proper parameters in
  providers {
    aws="aws.private"
  }

  ### General Variables

  ### Symphony vars
  db_class = "m4.large"
  db_version = "9.6.00"
  
  ### AWS vars
  #db_class = "db.m4.large"
  #db_version = "9.6.1"
}