module "network" {
  source   = "./module/vpc"
  cidr_vpc = "10.0.0.0/16"
  cidr_public1 = "10.0.1.0/24"
  cidr_public2 = "10.0.2.0/24"
  cidr_private1 = "10.0.11.0/24"
  cidr_private2 = "10.0.12.0/24"
  cidr_internet_gateway = "0.0.0.0/0"
  cidr_nat_gateway = "0.0.0.0/0"
  az1 = "ap-northeast-1a"
  az2 = "ap-northeast-1c"
}