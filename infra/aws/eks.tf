
# Cluster EKS, simple without module

resource "aws_eks_cluster" "main" {
    name     = var.eks_name
    role_arn = aws_iam_role.eks_cluster.arn
    version  = var.eks_version


    vpc_config {
        subnet_ids         = aws_subnet.public[*].id
        security_group_ids = [aws_security_group.eks_cluster.id]
    }

    depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

resource "aws_eks_node_group" "main" {
    cluster_name    = aws_eks_cluster.main.name
    node_group_name = "main-node-group"
    node_role_arn   = aws_iam_role.eks_nodes.arn
    subnet_ids      = aws_subnet.public[*].id

    scaling_config {
        desired_size = 2
        max_size     = 3
        min_size     = 1
    }

    instance_types = ["t3.medium"]

    depends_on = [
        aws_iam_role_policy_attachment.eks_worker_node_policy,
        aws_iam_role_policy_attachment.eks_cni_policy,
        aws_iam_role_policy_attachment.eks_container_registry_policy,
    ]
}