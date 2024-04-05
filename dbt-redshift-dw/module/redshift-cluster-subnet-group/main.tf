variable "vpc_subnet_ids" {
    description = "list of subnets to add to redshift cluster subnet group"
    type = list(string)
  
}
variable "redshift_cluster_subnet_group_name" {
    description = "name of the redshift cluster subnet group"
    default = "my-redshift-subnet-group"
  
}
resource "aws_redshift_subnet_group" "my_redshift_subnet_group" {
  name        = var.redshift_cluster_subnet_group_name
  description = "Redshift cluster subnet group"

  subnet_ids = var.vpc_subnet_ids
}
