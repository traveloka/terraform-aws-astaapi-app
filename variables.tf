variable "route53_private_zone_id" {
  type        = "string"
  description = "The ID of Route 53 private zone"
}

variable "vpc_id" {
  type        = "string"
  description = "The ID of the VPC this stacks belongs to"
}

variable "environment" {
  type        = "string"
  description = "The environment this stack belongs to"
}

variable "lb_subnet_ids" {
  type        = "list"
  description = "The list of subnet ids to attach to the LB"
}

variable "listener_certificate_arn" {
  type        = "string"
  description = "The ARN of the default SSL server certificate"
}

variable "lb_logs_s3_bucket_name" {
  type        = "string"
  description = "The s3 bucket where the LB access logs will be stored"
}

variable "lb_tg_health_check" {
  type        = "map"
  default     = {}
  description = "The ALB target group's health check configuration, will be merged over the default on locals.tf"
}

variable "ami_id" {
  type        = "string"
  description = "The AMI ID to spawn ASG instances from"
}

variable "user_data" {
  type        = "string"
  description = "The user data to be passesd to the launch configuration"
}

variable "lb_route53_record_name" {
  type        = "string"
  description = "The name of Route 53 record pointing to the LB. The default is the service name"
  default     = ""
}

variable "asg_min_capacity" {
  type        = "string"
  description = "Minimum ASG capacity"
}

variable "asg_max_capacity" {
  type        = "string"
  description = "Maximum ASG capacity"
}

variable "asg_vpc_zone_identifier" {
  type        = "list"
  description = "The list of subnet ids to spawn ASG instances to"
}

variable "ssm_policy_arn" {
  type        = "string"
  description = "SSM access policy arn to attach to instance profile of astopoc asg."
}

variable "commonEC2_policy_arn" {
  type        = "string"
  description = "Common EC2 Policy ARN"
}

variable "launch_template_override" {
  type        = "list"
  description = "List of nested arguments provides the ability to specify multiple instance types. See https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html#override"
}

variable "allow_read_s3_arn" {
  type        = "list"
  description = "List of S3 ARNs where astaapi can read"
}

variable "allow_write_s3_arn" {
  type        = "list"
  description = "List of S3 ARNs where astaapi can write"
}

variable "mixed_instances_distribution" {
  type        = "map"
  description = "Specify the distribution of on-demand instances and spot instances. See https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_InstancesDistribution.html"

  default = {
    on_demand_allocation_strategy            = "prioritized"
    on_demand_base_capacity                  = "0"
    on_demand_percentage_above_base_capacity = "50"
    spot_allocation_strategy                 = "lowest-price"
    spot_instance_pools                      = "2"
    spot_max_price                           = ""
  }
}