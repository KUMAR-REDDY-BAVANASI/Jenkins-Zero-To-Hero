# terraform {
#   backend "s3" {
#     bucket = "" # Bucket name
#     key    = "eks/kumar/terraform.tfstate"
#     region = "ap-south-1"
#     dynamodb_table = "" # Dynamodb table name
#   }
# }

module "eks" {
  source = "../modules/eks"

  cluster_name   = "dev-cluster"
  k8s_version    = "1.23"
  desired_size   = "1"
  min_size       = "1"
  max_size       = "1"
  instance_types = ["t2.medium", "t3.medium"]
}