variable "region" {
  description = "Region de la instancia"
  type        = string
  default     = "us-east-1"
}

variable "access_key" {
  description = "Access Key de la cuenta AWS"
  type        = string
  default     = "XXX"
}

variable "secret_key" {
  description = "Secret Key de la cuenta AWS"
  type        = string
  default     = "XXX" 
}

variable "ami" {
  description = "AMI de la instancia: informa a AWS que instancia queremos levantar"
  type        = string
  default     = "ami-007855ac798b5175e"//Last release Ubuntu, suele cambiar con el tiempo
}

variable "key_pair" {
  description = "Nombre par de claves para conexión segura a la instancia"
  type        = string
  default     = "ubuntu_keys"
}
