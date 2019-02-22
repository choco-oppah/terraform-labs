variable "loc" {
    description = "Default Azure region"
    default     =   "Southeast Asia"
}

variable "tags" {
    default     = {
        source  = "citadel"
        env     = "training"
    }
}