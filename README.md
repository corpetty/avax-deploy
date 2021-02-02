## Requirements
- host machine
  - docker installed
  - ansible installed (`python3 -m pip install ansible-base ansible`)
  - standard SSH keys from host file  
- remote machine (tested on Ubuntu 18.04 LTS)
  - ansible installed (`python3 -m pip install ansible-base ansible`)
  - host SSH public key in `.ssh/authorized_keys`
    - login to remote and copy your host SSH public key into the `~/.ssh/authorized_keys` file
    - `.ssh` directory should have `chmod 700` permissions
    - `authorized_keys` file should have `chmod 600` permissions
- On the remote, you will need to set a port-forward in your network firewall (your router probably) to:
  - `<remote machine LAN IP>:9651`
  
## Notes
- avalanchego DOES NOT compile on ARM64 architectures
- copy `config.env.example` and `inventory.yml.example` to their names with `example`
  - fill in any changes to `config.env`
  - put in your IP for `inventory.yml`
- All steps are in the Makefile, they will be updated to be more clear over time
- Certification files
  - If you do not have a genesis staking node, generate them with the makefile
  - If you have a genesis staking node, get keys and certs from me and do NOT run that makefile step. Instead just put the `staker.crt` and `staker.key` files in the `assets/cert_keys` directory

