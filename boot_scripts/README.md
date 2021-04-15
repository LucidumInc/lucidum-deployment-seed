# Lucidum Boot Scripts

The scripts in this directory are invoked by Terraform/Cloudformation when deploying to the cloud.\
\
On-Premises users, such as VMware, OpenStack, and bare-metal servers, can use these scripts directly to boostrap Lucidum:

0. Contact Lucidum Sales
   - Lucidum Enterprise AWS Secrets: needed to download containers from Lucidum AWS ECR\
   Provide us with your PGP public key and we will use it to encrypt and send you encrypted secrets\
   You can download GnuPG tools here: https://gnupg.org/

1. Boot official Ubuntu18 virtual machine
   - You can download the Lucidum supported ubuntu18 OVA from this link:\
   https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.ova \
   We recommend the following minimum resources: `memory 128G` `cpu 16 cores` `hard drive 1T SSD`\
   Ensure the virtual machine has internet connectivity. (Verify IP addressing, routing, firewall, http-proxy, etc).

2. Decrypt and set Lucidum Enterprise AWS Secrets in the appropriate boot script for your Operating System (e.g., Ubuntu, Amazon Linux, etc).  The boot scripts are located in the the `boot_scripts/` directory.  In the appropriate script for your OS, add values to these three variables at the top of the script: CUSTOMER_NAME, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY.  Summary:
   - Lucidum will provide you with an asc file containing the encrypted secrets
   - Use GnuPG, or any other PGP software, to decrypt
   - Set these secrets at the top of the script for your OS `boot_<yourOS>.sh`
```shell
$ gpg --decrypt customer.asc 
gpg: encrypted with 2048-bit RSA key, ID 0123456789ABCDEF, created 2020-10-06
      "Lucidum Customer <customer@lucidum.io>"
customer=<yourCustomerName>
aws_access_key_id=AKIA0123456789ABCDEF
aws_secret_access_key=<secret-string>
```

3. Execute `sudo bash boot_<yourOS>.sh`
   - Change to the `boot_scripts` directory.
   - For extra script verbosity, use the `-x` bash flag
```shell
$ sudo bash -x boot_ubuntu18.sh
...
5 features passed, 0 failed, 0 skipped
6 scenarios passed, 0 failed, 0 skipped
25 steps passed, 0 failed, 0 skipped, 0 undefined
Took 0m8.472s
+ touch /root/.lucidum_installed_customer
+ echo 'init lucidum complete'
init lucidum complete
removed '/root/install_lucidum.sh'
initialization complete
```

4. Instance setup is complete. You are now ready to configure data connectors.
