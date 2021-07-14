## Brief
The following terraform module is used to generate a user-data snippet which can be used to sign a host certificate when
an instance starts up. It depends on an AWS secret to be created which contains the host signing key. 

The host will also need an IAM profile that will allow it to access the secret, this should be attached to the instance role.

## Example
```terraform
module "autoscale_ssh_host_cert_handler" {
  source  = "github.com/patrontech/devops-tf-module-aws-ec2-host-cert?ref=v1.10.1"
  ssh_ca_signing_cert_secret_arn = "arn:aws:secretsmanager:#####"
  ec2_fqdn_tag = "FQDN"
}
resource "aws_launch_template" "ecs_node_group" {
  name                   = "${var.aws_base_tags.env_name}-app-ecs-node-group"
  .......
  .......
  user_data              = base64encode(autoscale_ssh_host_cert_handler.freeipa_userdata_snippet)
}