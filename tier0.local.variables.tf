variable "loc" {
    description = "Default Azure region"
    default     =   "southeastasia"
}

variable "webapplocs" {
    description = "Default Azure region"
    default     =   ["southeastasia", "eastasia", "koreacentral"]
}

variable "tags" {
    default     = {
        source  = "citadel"
        env     = "training"
    }
}