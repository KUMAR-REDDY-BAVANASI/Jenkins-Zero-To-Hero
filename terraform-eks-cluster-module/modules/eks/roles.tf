resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
            "eks.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ],
  "Version": "2008-10-17"
}
  EOF
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEBSCSIDriverPolicy" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_role" "eks-node-role" {
  name = "eks-node-role"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
          "Service": [
            "ec2.amazonaws.com"
          ]
      },
      "Action": [
          "sts:AssumeRole"
      ]
    }
  ],
  "Version": "2008-10-17"
}
  EOF

}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}


resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node-AmazonEBSCSIDriverPolicy" {
  role       = aws_iam_role.eks-node-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

resource "aws_iam_policy" "policy-autoscalar" {
  name        = "EKS-Node-group-IAM-policy-autoscalar-${var.cluster_name}"
  path        = "/"
  description = "EKS-Node-group-IAM-policy-autoscalar"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "EKS-Cluster-IAM-policy-autoscalar" {
  policy_arn = aws_iam_policy.policy-autoscalar.arn
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "EKS-Node-group-IAM-policy-autoscalar" {
  policy_arn = aws_iam_policy.policy-autoscalar.arn
  role       = aws_iam_role.eks-node-role.name
}