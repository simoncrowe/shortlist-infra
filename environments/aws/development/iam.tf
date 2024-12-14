data "aws_iam_policy_document" "send_email" {
  statement {
    actions   = ["ses:SendRawEmail", "ses:SendEmail"]
    resources = [module.email.ses_domain_identity_arn]
  }
}

resource "aws_iam_policy" "send_email" {
  name = "send-emails"

  description = "Allows sending of emails from the development domain"

  policy = data.aws_iam_policy_document.send_email.json
}

resource "aws_iam_group" "email_senders" {
  name = "email-senders"
}

resource "aws_iam_group_policy_attachment" "email_senders" {
  group      = aws_iam_group.email_senders.name
  policy_arn = aws_iam_policy.send_email.arn
}


resource "aws_iam_user" "email_sender" {
  name = "email-sender"

}

resource "aws_iam_group_membership" "email_senders" {
  name = "email-senders-group-membership"

  users = [aws_iam_user.email_sender.name]

  group = aws_iam_group.email_senders.name
}
