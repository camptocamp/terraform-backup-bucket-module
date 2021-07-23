resource "aws_s3_bucket" "this" {

  bucket = var.name
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "this" {

  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_iam_user" "this" {
  name = var.name
  path = "/services/"
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_iam_user_policy" "this" {
  user   = aws_iam_user.this.name
  policy = data.aws_iam_policy_document.this.json
}
