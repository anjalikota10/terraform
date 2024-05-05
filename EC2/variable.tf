
variable "ami_type" {
  type        = string
  default     = "ami-05e00961530ae1b55"
  description = "enter ami of ubuntu 22.04 in mumbai region"

}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "provide type of instance as per requirement "

}

locals {
  common_tags = {
    "Environment" = "production"
    "Type"        = "webserver"
  }
}