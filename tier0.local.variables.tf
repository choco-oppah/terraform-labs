variable "loc" {
    description = "Default Azure region"
    default     =   "southeastasia"
}

variable "webapplocs" {
    description = "List of locations for web apps"
    type        = "list"
    default     =   []
}

variable "tags" {
    default     = {
        source  = "citadel"
        env     = "training"
    }
}