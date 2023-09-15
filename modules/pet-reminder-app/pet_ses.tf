

resource "aws_sesv2_email_identity" "example" {
  email_identity = each.value
  for_each = toset(var.emails)
}


