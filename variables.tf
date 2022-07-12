variable "ami_string" {
  type = string
  default = "no input ami"
  description = "sample input"
}

variable "ec2_tags" {
  type = object({
    Name = string
    Foo = number
  }
  )
}
variable "sample_list" {
    type = list
    default = [ 1, 2, 3]
    description = "sample list variable but not in use"
}
