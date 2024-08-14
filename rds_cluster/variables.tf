variable "name" {
  type        = string
  description = "Determines naming convention of assets. Generally follows DNS naming convention."
}

variable "database_name" {
  type        = string
  description = "Name of the default database to create"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the vpc the database belongs to"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for the database"
}

variable "database_subnets" {
  type        = list(string)
  description = "Subnets for the database"
}

variable "additional_security_groups" {
  type        = list(string)
  default     = []
  description = "Any additional security groups the cluster should be added to"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the AWS resources."
  default     = {}
}

variable "instance_count" {
  type        = number
  description = "How many RDS instances to create"
}

variable "instance_class" {
  type        = string
  description = "Instance class"
}

variable "ca_cert_identifier" {
  type        = string
  description = "Identifier of the CA certificate for the DB instance"
  default     = null
}
