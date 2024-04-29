# Define the IAM role for the EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "EKSclusterrole1" # Name of the IAM role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach the AmazonEKSClusterPolicy to the IAM role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  role       = "EKSclusterrole1"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Create the EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = "EKS-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.29" # Change to the desired Kubernetes version

  vpc_config {
    subnet_ids         = ["subnet-0520457db0f0538cc", "subnet-043e9935ca1289094"] # Specify the subnet IDs
    security_group_ids = ["sg-088075be1368eef9e"]                                 # Specify the security group IDs
  }
}

provider "aws" {
  region = "us-west-2"  # Update with your desired AWS region
}

# Define IAM role for EKS node group
resource "aws_iam_role" "workernodepolicy" {
  name               = "workernodepolicy"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}

# Attach policies to the IAM role
resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.workernodepolicy.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.workernodepolicy.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.workernodepolicy.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# Define EKS node group
resource "aws_eks_node_group" "example" {
  cluster_name    = "EKS-cluster"
  node_group_name = "WorkerNodePolicy2"
  node_role_arn   = aws_iam_role.workernodepolicy.arn
  # Other configurations for your node group...
  subnet_ids = ["subnet-0520457db0f0538cc", "subnet-043e9935ca1289094"]  # Specify the subnets for the node group

  scaling_config {
    desired_size = 3
    max_size     = 5
    min_size     = 2
  }

  instance_types = ["t3.medium"]  # Specify the instance types for the nodes

  tags = {
    Environment = "production"
  }
}





