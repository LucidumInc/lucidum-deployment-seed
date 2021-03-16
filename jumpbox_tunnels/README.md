# Jumpbox Tunnels

SystemD initialization scripts allow customers to create persistent reverse ssh tunnels via SystemD process management.
  1. Provide us with the SSH Public Key associated with your connection.\
     If you do not have a pubkey, generate it with `ssh-keygen`.
  2. Provide us with the Public IP your connection will be coming from. \
     We will need to whitelist your IP address in our firewalls.
  3. Copy two SystemD units into `/etc/systemd/system`
  4. Enable services:\
     `systemctl enable lucidum-jumpbox-primary`\
     `systemctl enable lucidum-jumpbox-secondary`
  5. Start services:\
     `systemctl start lucidum-jumpbox-primary`\
     `systemctl start lucidum-jumpbox-secondary`
