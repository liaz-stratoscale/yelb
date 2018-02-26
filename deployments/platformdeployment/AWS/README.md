## Cloud Voter App (Yelb) Cloud Deployment
This terraform module and files will deploy the yelb app on either an aws public cloud, or on Symphony, using the same api's and flows.

### Usage
1. Fill in your Symphony cluster / AWS details and access keys in the `terraform.tfvars` file.
2. On the 'yelb' module file, modify the providers property to point at `aws.private` or `aws.public`
3. The deployment currently assumes an ubuntu 16 ami pre-installed with: `docker`, `psql 9.6 client`, `pulled docker images`

Upcoming future versions will use a clean ubuntu 16 AMI.

### Known issues
- Symphony doesn't come pre-built with the same db.m1.medium instance type, you can create it manually.






