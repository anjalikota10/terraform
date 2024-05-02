
resource "aws_iam_user" "user" {
  for_each = toset(["devops"])
  name     = each.key
  path     = "/"

  tags = {
    tag-key = "each.value"
  }
}

#Create an IAM role
resource "aws_iam_role" "my_role" {
  name               = "EC2terraformrole"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::660665532013:user/devops"  # Allow the IAM user to assume this role
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Step 3: Attach policies to the IAM role
resource "aws_iam_role_policy_attachment" "my_policy_attachment" {
  role       = "EC2terraformrole"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"  # Example policy ARN
}

# Step 4: Create an IAM policy attachment to associate the IAM role with the IAM user
resource "aws_iam_user_policy_attachment" "my_user_policy_attachment" {
  user       = "devops"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}