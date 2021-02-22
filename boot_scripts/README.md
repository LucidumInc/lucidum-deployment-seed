# Lucidum Boot Scripts

Scripts are invoked by Terraform/Cloudformation as instance userdata.

### VMWare / On-Premesis Deployments

Users can execute boot scripts directly.

0. Contact sales and obtain enterprise license\
   Provide us with your GPG public key and we will provide you with Lucidum Enterprise secrets\
   ** https://gnupg.org/ **
   

1. Boot official Ubuntu18 virtual machine\
   ** https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.ova **

2. Set Lucidum Enterprise secrets in `boot_ubuntu18.sh`

3. Execute `bash boot_ubuntu18.sh`

4. Navigate to UI portal and enter license key https://[instance-ip]/CMDB

We recommend the following minimum resources:
`memory 128G`
`cpu 16 cores`
`hard drive 1T SSD`
