module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.27.0"

  cluster_name    = "demo"
  cluster_version = "1.25"
  enable_irsa     = true

  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnets

  managed_node_groups = {
    role = {
      capacity_type   = "SPOT"
      node_group_name = "general"
      instance_types  = ["t3a.large"]
      desired_size    = "1"
      max_size        = "2"
      min_size        = "1"
    }
  }
}