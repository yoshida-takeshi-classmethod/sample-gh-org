# see https://www.terraform.io/docs/configuration/terraform.html
terraform {
  required_version = "~> 1.10.5"

  required_providers {
    github = {
      source  = "hashicorp/github"
      version = "~> 6.5.0"
    }
  }

  backend "s3" {
    bucket = "" #S3バケット名を指定
    key    = "" #tfstateファイル用のKeyを指定。特に命名規則がなければ、「{Org名}/{リポジトリ名}/tfstate」で指定することを推奨
    region = "ap-northeast-1"
    acl    = "bucket-owner-full-control"
  }
}
