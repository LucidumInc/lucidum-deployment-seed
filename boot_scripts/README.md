# Lucidum Boot Scripts

Scripts are invoked by Terraform/Cloudformation as instance userdata.

### VMWare / On-Premesis Deployments

Users can execute boot scripts directly.

0. boot official Ubuntu18 virtual machine

1. set secrets in `boot_ubuntu18.sh`

2. execute `bash boot_ubuntu18.sh`


We recommend the following minimum resources:
`memory 128G`
`cpu 16 cores`
`hard drive 1T SSD`
