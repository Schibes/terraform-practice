variable vpc_cidr {
    type = string
    default = "10.0.0.0/16"
}

variable primary_subnet {
    type = string
    default = "10.0.1.0/24"
}

variable secondary_subnet {
    type = string
    default = "10.0.2.0/24"
}

variable ubuntu16_ami {
    type = string
    default = "ami-0d563aeddd4be7fff" #us-east-2
}