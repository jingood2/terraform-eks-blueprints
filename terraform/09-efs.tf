resource "aws_efs_file_system" "eks" {
  creation_token = "eks"

  performance_mode = "generalPurpose"
  throughput_mode = "bursting" 
  encrypted = true

  tags = {
    Name = "eks"
  }
}

resource "aws_efs_mount_target" "zone" {
  for_each = toset(module.vpc.private_subnets)

  file_system_id = aws_efs_file_system.eks.id
  subnet_id      = each.key
  security_groups = [module.eks_blueprints.cluster_primary_security_group_id]
}

resource "kubernetes_storage_class" "example" {
  metadata {
    name = "efs"
  }

  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId = aws_efs_file_system.eks.id
    directoryPerms = "700"
    type = "pd-standard"
  }
  mount_options = ["iam"]

  depends_on = [module.kubernetes_addons]
}