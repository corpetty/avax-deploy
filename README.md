## Requirements
- docker on host machine
- provisioned machine (tested on Ubuntu 18.04 LTS)
  - avalanchego DOES NOT compile on ARM64 architectures
- ansible on both host and provisioned machine
  - `python3 -m pip install ansible-base ansible`
- standard SSH keys from host file

## Notes
- login to host and copy your SSH public key into the `~/.ssh/authorized_keys` file
  - `.ssh` directory should have `chmod 700` permissions
  - `authorized_keys` file should have `chmod 600` permissions
- copy `config.env.example` and `inventory.yml.example` to their names with `example`
  - fill in any changes to `config.env`
  - put in your IP for `inventory.yml`
- All steps are in the Makefile, they will be updated to be more clear over time
  - If you do not have a genesis stakign node, generate them with the makefile
  - If you have a genesis staking node, get keys and certs from me and do NOT run that makefile step. Instead just put the `staker.crt` and `staker.key` files in the `assets/cert_files` directory

