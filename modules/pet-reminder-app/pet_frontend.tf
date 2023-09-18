resource "aws_s3_bucket" "pet_frontend" {
  bucket = "pet-frontend-1723"
   
  }

  
resource "aws_s3_bucket_public_access_block" "pet_frontend" {
  bucket = aws_s3_bucket.pet_frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.pet_frontend.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    sid = "PublicRead"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.pet_frontend.arn,
      "${aws_s3_bucket.pet_frontend.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_website_configuration" "pet_frontend" {
  bucket = aws_s3_bucket.pet_frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}
resource "aws_s3_bucket_ownership_controls" "pet_frontend" {
  bucket = aws_s3_bucket.pet_frontend.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}



resource "aws_s3_bucket_acl" "pet_frontend" {
  depends_on = [
    aws_s3_bucket_ownership_controls.pet_frontend,
    aws_s3_bucket_public_access_block.pet_frontend,
  ]

  bucket = aws_s3_bucket.pet_frontend.id
  acl    = "public-read"
}



resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.pet_frontend.bucket
  key    = each.key
  source = each.value[0]
  for_each = var.pet_frontend_content
  content_type = each.value[1]
  
}

output "pet_frontend_endpoint" {
    value = aws_s3_bucket_website_configuration.pet_frontend.website_endpoint
  
}