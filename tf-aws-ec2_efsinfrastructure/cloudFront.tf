resource "aws_cloudfront_distribution" "s3_distribution" {
    depends_on = [
        aws_efs_mount_target.efs-mount,
        aws_s3_bucket_object.file_upload,
    ]

    origin {
        domain_name = "${aws_s3_bucket.mybucket.bucket}.s3.amazonaws.com"
        origin_id   = "ak"
    }

    enabled         = true
    is_ipv6_enabled = true
    default_root_object = "index.html"

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    default_cache_behavior {
        allowed_methods = ["HEAD", "GET"]
        cached_methods = ["HEAD", "GET"]
        forwarded_values {
            query_string = false
            cookies {
                forward = "none"
            }
        }
        default_ttl            = 3600
        max_ttl                = 86400
        min_ttl                = 0
        target_origin_id       = "ak"
        viewer_protocol_policy = "allow-all"
    }

    price_class = "PriceClass_All"

    viewer_certificate {
        cloudfront_default_certificate = true
    }
}
# -- Updating cloudfront_url to main location

resource "null_resource" "nullremote3" {
    depends_on = [
        aws_cloudfront_distribution.s3_distribution,
    ]
}