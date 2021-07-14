variable "ssh_ca_signing_cert_secret_arn" {
  description = "SSH CA Signing Certificate (to be stored as an AWS Secret"
  type = string
}

variable "ec2_fqdn_tag" {
  description = "AWS Tag which contains the instance's FQDN"
}