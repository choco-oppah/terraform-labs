variable "loc" {
    description = "Default Azure region"
    default     =   "southeastasia"
}

variable "webapplocs" {
    description = "Default Azure region"
    default     =   ["eastasia", "southeastasia", "koreacentral"]
}

variable "tags" {
    default     = {
        source  = "citadel"
        env     = "training"
    }
}