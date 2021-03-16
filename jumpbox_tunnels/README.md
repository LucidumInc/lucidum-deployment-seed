# Jumpbox Tunnels

SystemD initialization scripts allow customers to create persistent reverse ssh tunnels via SystemD process management.
  1. Provide us with the SSH Public Key associated with your connection.\
     If you do not have a pubkey, generate it with `ssh-keygen`.
  2. Provide us with the Public IP your connection will be coming from. \
     We will need to whitelist your IP address in our firewalls.
  3. Append the SSH Public Key we provide to the `ubuntu` user's authorized keys.\
     This is different from the SSH Public Key you provide us, and is appended to:\
     `/home/ubuntu/.ssh/authorized_keys`
  4. Copy two SystemD unit files into `/etc/systemd/system`\
     `/etc/systemd/system/lucidum-jumpbox-primary.service`\
     `/etc/systemd/system/lucidum-jumpbox-secondary.service`
  5. Update `CUSTOMER_NAME` and `CUSTOMER_PORT` in the two unit files.\
     These values will be provided to you directly.
  6. Enable services:\
     `systemctl enable lucidum-jumpbox-primary`\
     `systemctl enable lucidum-jumpbox-secondary`
  7. Start services:\
     `systemctl start lucidum-jumpbox-primary`\
     `systemctl start lucidum-jumpbox-secondary`
