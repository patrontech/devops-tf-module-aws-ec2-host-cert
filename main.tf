## The following file is responsible for signing a hosts SSH certificate to make it easier to login to.
data "template_file" "userdata_snippet" {
  template = file("${path.module}/bash.tpl")
  vars = {
    ec2_fqdn_tag        = var.ec2_fqdn_tag
    aws_secret_id       = var.ssh_ca_signing_cert_secret_arn
  }
}