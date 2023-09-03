variable "zone" {
  type = string
  default = "ru-central1-a" # зона доступности, можно не менять

}

variable "cloud_id" {
  type = string
  default = "b1gmrlsb9f70ac226au7" # нужен свой cloud_id
}

variable "folder_id" {
  type = string
  default = "b1gbso9k07p4sob6ogrd" # нужен свой folder_id
}

variable "image_id" {
  type = string
  default = "fd879gb88170to70d38a" # образ VM, можно не менять
}