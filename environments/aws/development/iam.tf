resource "aws_iam_openid_connect_provider" "gke_cluster" {
  url            = "https://${var.gke_oidc_issuer_hostpath}"
  client_id_list = ["sts.amazonaws.com"]
}


data "aws_iam_policy_document" "send_email" {
  statement {
    actions   = ["ses:SendRawEmail", "ses:SendEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "send_email" {
  name = "send-emails"

  description = "Allows sending of emails from the development domain"

  policy = data.aws_iam_policy_document.send_email.json
}

data "aws_iam_policy_document" "gke_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.gke_cluster.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.gke_oidc_issuer_hostpath}:sub"
      values   = [var.k8s_service_account_id]
    }
  }
}

resource "aws_iam_role" "email_sender" {
  name               = "email-sender"
  assume_role_policy = data.aws_iam_policy_document.gke_assume_role.json
}


resource "aws_iam_role_policy_attachment" "email_sender" {
  role       = aws_iam_role.email_sender.name
  policy_arn = aws_iam_policy.send_email.arn
}
