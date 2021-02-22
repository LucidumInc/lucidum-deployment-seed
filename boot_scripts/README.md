# Lucidum Boot Scripts

Scripts are invoked by Terraform/Cloudformation as instance userdata.

### VMWare / On-Premesis Deployments

Users can execute boot scripts directly.

0. boot official Ubuntu18 virtual machine\
   ** https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.ova **

1. set secrets in `boot_ubuntu18.sh`

2. execute `bash boot_ubuntu18.sh`

3. navigate to Lucidum portal and enter license key https://[instance-ip]/CMDB

We recommend the following minimum resources:
`memory 128G`
`cpu 16 cores`
`hard drive 1T SSD`
