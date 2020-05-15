resource "aws_iam_instance_profile" "default" {
  name = join("", [var.name, "-ecs-instance-profile"])
  role = aws_iam_role.ecs-ec2-role.name
}

resource "aws_iam_role" "ecs-ec2-role" {
  name = join("", [var.name, "ecs-instance-role"])
  path = "/ecs/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ecs-ebs-policy" {
  name = "MongoEBSFullAccess"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
               "ec2:AttachVolume",
                "ec2:CreateVolume",
                "ec2:CreateSnapshot",
                "ec2:CreateTags",
                "ec2:DeleteVolume",
                "ec2:DeleteSnapshot",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInstances",
                "ec2:DescribeVolumes",
                "ec2:DescribeVolumeAttribute",
                "ec2:DescribeVolumeStatus",
                "ec2:DescribeSnapshots",
                "ec2:CopySnapshot",
                "ec2:DescribeSnapshotAttribute",
                "ec2:DetachVolume",
                "ec2:ModifySnapshotAttribute",
                "ec2:ModifyVolumeAttribute",
                "ec2:DescribeTags"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-ec2-container-service-policy-attachement" {
  role       = aws_iam_role.ecs-ec2-role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs-ec2-ssm-policy-attachement" {
  role       = aws_iam_role.ecs-ec2-role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs-ec2-ebs-policy-attachment" {
  policy_arn = aws_iam_policy.ecs-ebs-policy.arn
  role       = aws_iam_role.ecs-ec2-role.id
}
