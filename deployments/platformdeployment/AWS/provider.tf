provider "aws" {
  alias="private"
  access_key = "${var.symp_access_key}"
  secret_key = "${var.symp_secret_key}"

  endpoints {
    ec2 = "https://${var.symphony_ip}/api/v2/ec2"
    elb = "https://${var.symphony_ip}/api/v2/aws/elb"
    rds = "https://${var.symphony_ip}/api/v2/aws/rds"
  }

  insecure = "true"
  skip_metadata_api_check = true
  skip_credentials_validation = true

  # No importance for this value currently
  region = "us-east-2"
}


provider "aws" {
  alias = "public"

  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "us-east-1"
}