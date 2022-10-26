resource "random_pet" "pet" {
  length    = 5
  separator = ""
}

output "pet" {
  value = random_pet.pet
}

resource "random_string" "random_string" {
  length  = 4
  special = false
  lower   = true
  upper   = false
}

output "random_string" {
  value = random_string.random_string
}


resource "aws_s3_bucket" "bucket" {

  bucket        = "${random_pet.pet.id}-${random_string.random_string.id}"
  acl           = "private"
  force_destroy = true
}


locals {
  files = tolist(fileset(var.folder_to_upload, "*"))
}

resource "aws_s3_bucket_object" "object" {
  count  = length(local.files)
  bucket = aws_s3_bucket.bucket.bucket
  key    = local.files[count.index]
  source = "${var.folder_to_upload}/${local.files[count.index]}"


}
