variable "resource-group-name" {
    type                        = string
    default                     = "Cloud_MSA-Dev-Test"
}

variable "azure-location" {
    type                        = string
    default                     = "Korea Central"
}

variable "vnet-name" {
    type                        = string
    # 이름은 2~64자 사이여야 합니다.
    # 이름은 영문, 숫자, 밑줄, 마침표 또는 하이픈만 포함할 수 있습니다. 단 영문 또는 숫자로 시작하고 영문, 숫자 또는 밑줄로 끝나야 합니다.
    # 값은 비어 있으면 안 됩니다.
    default                     = "MSA-vnet"
}

variable "vnet-cidr" {
    type                        = string
    default                     = "192.168.0.0/16"
}

variable "internet-cidr" {
    type                        = string
    default                     = "0.0.0.0/0"
}

variable "public-subnet-name" {
    type                        = string
    # 이름은 영문, 숫자, 밑줄, 마침표 또는 하이픈만 포함할 수 있습니다. 단 영문 또는 숫자로 시작하고 영문, 숫자 또는 밑줄로 끝나야 합니다.
    default                     = "public-subnet"
}

variable "public-subnet-sg-name" {
    type                        = string
    default                     = "MSA-public-subnet-security-group"
}

variable "private-subnet-name" {
    type                        = string
    default                     = "private-subnet"
}

variable "subnet-cidrs" {
    type                        = map(string)
    default                     = {
        "public"  = "192.168.0.0/24"
        "private" = "192.168.10.0/24"
        }
}

variable "public-nat-name" {
    type                        = string
    default                     = "MSA-ngw"
}

variable "public-nat-ip-name" {
    type                        = string
    default                     = "MSA-nat-gw-public-ip"
}

variable "nat-gateway-allocation-method" {
    type                        = string
    default                     = "Static"
}

variable "nat-gateway-public-sku" {
    type                        = string
    default                     = "Standard"
}

variable "tagging" {
    type                        = map(string)
    default                     = {
        "Create by" = "kmpark"
        "terraform" = "true"
    }
}