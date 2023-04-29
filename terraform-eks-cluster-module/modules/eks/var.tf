variable "cluster_name" {
  default = "demo"
}

variable "k8s_version" {
  default = "1.22"
}

variable "desired_size" {
  default = "1"
}


variable "max_size" {
  default = "1"
}

variable "min_size" {
  default = "1"
}


variable "instance_types" {
  default = ["t2.micro", "t3.micro"]
  type    = list(string)
}