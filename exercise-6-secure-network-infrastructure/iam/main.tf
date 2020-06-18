/******************************************************************************************
* This file implements IAM users and policies as per the assignment requirements          *
* It creates the AWS resources for 3 different types of users                             *
******************************************************************************************/


provider "aws" {
  region = "us-east-1"
}

# Create an Read-Only user that can view network and compute resources but not change them

resource "aws_iam_user" "aws_read_only" {
  name = "aws_read_only"
}

data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_user_policy_attachment" "ro_attach" {
  user = aws_iam_user.aws_read_only.name
  policy_arn = data.aws_iam_policy.ReadOnlyAccess.arn
}

# Create a user that can modify the specified bucket but nothing else

resource "aws_iam_user" "s3_user" {
  name = "s3-user"
}

data "aws_iam_policy_document" "s3_image_bucket_access" {
  statement {
    effect = "Allow"
    actions = [ "s3:ListAllMyBuckets", "s3:GetBucketLocation" ]
    resources = [ "arn:aws:s3:::*" ]
  }

  statement {
    effect = "Allow"
    actions = [ "s3:ListBucket" ]
    resources = [ "arn:aws:s3:::pub-cloud-image" ]
  }

  statement {
    effect = "Allow"
    actions = [ "s3:ListBucket", "s3:GetObject", "s3:PutObject" ]
    resources = [ "arn:aws:s3:::pub-cloud-image/*" ]
  }
}

resource "aws_iam_policy" "s3_image_bucket_access_policy" {
  name = "s3-image_bucket_access"
  policy = data.aws_iam_policy_document.s3_image_bucket_access.json
}

resource "aws_iam_user_policy_attachment" "s3_attach" {
  user = aws_iam_user.s3_user.name
  policy_arn = aws_iam_policy.s3_image_bucket_access_policy.arn
}

# Create Compute Admin user that view networking resources and modify compute resources

resource "aws_iam_user" "compute_admin" {
  name = "compute-admin"
}

# Read in the compute-admin.json file for the policy

resource "aws_iam_policy" "compute_admin_policy" {
  policy = file("compute-admin.json")
}

resource "aws_iam_user_policy_attachment" "compute_attach" {
  user = aws_iam_user.compute_admin.name
  policy_arn = aws_iam_policy.compute_admin_policy.arn
}

# Create a IAM Role for CloudWatch access to suppport connection logging on the Jump Server

resource "aws_iam_role" "cw_role" {
  name = "cw-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name  = "cw-role"
  }
}

resource "aws_iam_role_policy_attachment" "cw_role_attach" {
  role = aws_iam_role.cw_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
