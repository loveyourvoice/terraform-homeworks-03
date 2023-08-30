###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}
variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
}
variable "public_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiRBVQo4GLJAIOLLuuSe8GMlXNFbW93L0FfOmOk9Pni plotnikov@technolight.ru"
  description = "ssh-keygen -t ed25519"
}

variable "spec_vms" {
  type = list(object(
  {
    name          = string
    cores         = number
    memory        = number
    size          = number
    core_fraction = number
  }))
  default = [
    {
    name          = "main"
    cores         = 2
    memory        = 2
    size          = 5
    core_fraction = 20
    },
    {
    name          = "replica"
    cores         = 4
    memory        = 4
    size          = 10
    core_fraction = 5
    }  
  ]
}