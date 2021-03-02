# Lucidum Boot Scripts

The scripts in this directory are invoked by Terraform/Cloudformation when deploying to the cloud.\
\
On-Premesis users, such as VMware, OpenStack, and bare-metal servers, can use these scripts directly to boostrap Lucidum:

0. Contact Lucidum Sales
   - Lucidum Enterprise AWS Secrets: needed to download containers from Lucidum AWS ECR\
   Provide us with your PGP public key and we will use it to encrypt and send you encrypted secrets\
   You can download GnuPG tools here: https://gnupg.org/

1. Boot official Ubuntu18 virtual machine
   - You can download the Lucidum supported ubuntu18 OVA from this link:\
   https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.ova \
   We recommend the following minimum resources: `memory 128G` `cpu 16 cores` `hard drive 1T SSD`\
   Ensure the virtual machine has internet connectivity. (Verify IP addressing, routing, firewall, http-proxy, etc).

2. Decrypt Lucidum Enterprise AWS Secrets and set in `boot_ubuntu18.sh`
   - You will be provided with an asc file containing the encrypted secrets
   - use GnuPG, or any other PGP software, to decrypt
```shell
$ gpg --decrypt customer.asc 
gpg: encrypted with 2048-bit RSA key, ID 0123456789ABCDEF, created 2020-10-06
      "Lucidum Customer <customer@lucidum.io>"
aws access id AKIA0123456789ABCDEF
aws secret key secret-string
```

3. Execute `sudo bash boot_ubuntu18.sh`
   - change to the `boot_scripts` directory.
   - for extra verbosity, use the `-x` bash flag

4. Instance setup is complete. You are now ready to configure data connectors.
