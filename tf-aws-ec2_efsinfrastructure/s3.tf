# -- Creating S3 Bucket

resource "aws_s3_bucket" "mybucket" {
    bucket = "homan112233"
    acl    = "public-read"

    tags = {
        Name = "homan112233"
    }
}

# -- Uploading files in S3 bucket

resource "aws_s3_bucket_object" "file_upload" {
    depends_on = [
        aws_s3_bucket.mybucket
    ]
    bucket     = "homan112233"
    key        = "badge.webp"
    source     = "~/Documents/Pictures/badge.webp"
    acl        = "public-read"
}