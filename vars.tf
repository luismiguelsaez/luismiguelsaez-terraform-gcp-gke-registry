variable "region" {
    type = string
}

variable "project" {
    type = string
}

variable "gke_name" {
    type = string
    default = "testing"
} 

variable "gke_network" {
    type = string
    default = "default"
}

variable "gke_subnetwork" {
    type = string
    default = "default"
} 