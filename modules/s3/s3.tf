resource "aws_s3_bucket" "sample_bucket" {
  bucket = "${local.app_name}-sample-${local.environment}" //Terragruntで作成するバケット[^2]
}
