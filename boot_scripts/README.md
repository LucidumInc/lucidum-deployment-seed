# Lucidum Boot Scripts

Scripts are invoked by Terraform/Cloudformation as instance userdata.

### VMWare / On-Premesis Deployments

Users can execute boot scripts directly.

0. Contact Lucidum Sales:
   - Lucidum License Key: needed to unlock Lucidum UI
   - Lucidum Enterprise AWS Secrets: needed to download containers from Lucidum AWS ECR\
   Provide us with your GPG public key and we will use it to encrypt and send you encrypted secrets\
   You can download GPG tools here: https://gnupg.org/

1. Boot official Ubuntu18 virtual machine\
   You can download the Lucidum supported ubuntu18 OVA from this link:\
   https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.ova\
   We recommend the following minimum resources: `memory 128G` `cpu 16 cores` `hard drive 1T SSD`

2. Decrypt Lucidum Enterprise AWS Secrets and set in `boot_ubuntu18.sh`

3. Execute `bash boot_ubuntu18.sh`

4. Navigate to Lucidum UI portal and enter Lucidum License Key https://[your-lucidum-instance-ip]/CMDB

5. Instance setup is complete. You are now ready to configure data injestion connectors.
