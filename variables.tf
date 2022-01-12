variable "bucket" {
  type = object({
    name = string
  })
  default = null
}

variable "kms" {
  type = object({
    admins = list(string)
    access = list(string)
  })
  default = null
}
