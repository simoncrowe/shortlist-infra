resource "aws_iam_openid_connect_provider" "gke_cluster" {
  url             = var.gke_oidc_issuer_url  
  client_id_list  = ["sts.amazonaws.com"]
}


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

data "aws_iam_policy_document" "gke_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.gke_cluster.arn]
    }

    condition {
      test = "StringEquals"
      variable = "${var.gke_oidc_issuer_hostname}:sub"
      values = ["system:serviceaccount:default:${var.gke_service_account_id}"]
    }
  }
}

resource "aws_iam_role" "email_sender" {
  name = "email-sender"
  assume_role_policy = data.aws_iam_policy_document.gke_assume_role
}


resource "aws_iam_role_policy_attachment" "email_sender" {
  role = aws_iam_role.email_sender
  policy_arn = aws_iam_policy.send_email.arn
}
