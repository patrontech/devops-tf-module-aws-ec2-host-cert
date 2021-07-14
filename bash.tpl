#!/bin/bash
# The following script creates a signed ssh host certificate using a value from AWS Secrets Manager
# we may duplicate calls as we can't gaurantee this gets run in order with another script.
REGION="`curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`"
INSTANCE_ID="`curl --silent http://instance-data/latest/meta-data/instance-id`"
TAG_NAME="${ec2_fqdn_tag}"
FQDN="`aws ec2 describe-tags --filters \"Name=resource-id,Values=$INSTANCE_ID\" --region $REGION \"Name=key,Values=$TAG_NAME\" | jq -r .Tags[0].Value`"
HOSTNAME="`awk -F. '{print $1}' <<< $FQDN`"
aws secretsmanager get-secret-value --region "$REGION" --secret-id ${aws_secret_id} --query 'SecretString' | jq -r .ca_private_key``" > /tmp/ssh_ca
chmod 0600 /tmp/ssh_ca
ssh-keygen -h -s /tmp/ssh_ca -n "$HOSTNAME","$FQDN" -I "ecdsa_ssh_id" /etc/ssh/ssh_host_ecdsa_key.pub
ssh-keygen -h -s /tmp/ssh_ca -n "$HOSTNAME","$FQDN" -I "ed25519_ssh_id" /etc/ssh/ssh_host_ed25519_key.pub
ssh-keygen -h -s /tmp/ssh_ca -n "$HOSTNAME","$FQDN" -I "rsa_ssh_id" /etc/ssh/ssh_host_rsa_key.pub
rm /tmp/ssh_ca
sed -i -e '$a\\' /etc/ssh/sshd_config
sed -i -e '$aHostCertificate /etc/ssh/ssh_host_ecdsa_key-cert.pub' /etc/ssh/sshd_config
sed -i -e '$aHostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub' /etc/ssh/sshd_config
sed -i -e '$aHostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub' /etc/ssh/sshd_config
sed -i -e '$a\\' /etc/ssh/sshd_config
systemctl restart sshd