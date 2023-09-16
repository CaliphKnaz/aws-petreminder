

resource "aws_sesv2_email_identity" "pet_emails" {
  email_identity = each.value
  for_each = toset(var.emails)
  lifecycle {
    prevent_destroy = true
  }
}


