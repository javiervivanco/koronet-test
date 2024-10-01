variable "aws_region" {
    type        = string
    default     = "us-east-2"
}

variable "eks_name" {
    type        = string
    default     = "koronet-eks"
}
variable "eks_version" {
    type        = string
    default     = "1.30"
}
