## Terms used
- *[HOST]: A development machine that uses Ansible and Docker to build Statalanche binaries, deploy them to a REMOTE machine, and configure the REMOTE machine to run Statalanche
- *[REMOTE]: A server that is configured to run Statalanche binaries and nothing else. 
- *[AVAX]: A reference to the Statalanche binary, and its associated environment variables 

## Requirements
- HOST machine
  - docker installed
  - ansible installed (`python3 -m pip install ansible-base ansible`)
  - standard SSH keys from host file  
- REMOTE machine (tested on Ubuntu 18.04 LTS)
  - ansible installed (`python3 -m pip install ansible-base ansible`)
  - host SSH public key (host's `~/id_rsa.pub`) in `.ssh/authorized_keys`
    - login to REMOTE and copy your host SSH public key into the `~/.ssh/authorized_keys` file
    - `.ssh` directory should have `chmod 700` permissions
    - `authorized_keys` file should have `chmod 600` permissions
  - ensure the port `9653` (optionally RPC port `9655` as well) is publicly accessible 
    - if running on your local LAN behind your router, set a port-forward in your network firewall (your router probably) to:
      - `<WAN address (your public IP)>:9653` ===> `<LAN address IP>:9653`
    - for a cloud instance, ensure that you've enabled the port `9653` in your cloud dashboard
      - if you'd like to query the RPC, then also enable `9655`
  
## Notes
- avalanchego DOES NOT compile on ARM64 architectures via this method. You will need to do it manually on the remote host.

## Instructions
Ansible works by connecting to your REMOTE machine and "doing things" via SSH from your local development machine, HOST. So all steps taken should be done on a system _THAT IS NOT RUNNING_ Statalanche, which we call the HOST machine. These scripts are for managing a different computer that will be configured to run Statalanche, which we call the REMOTE machine.

1. Prep the HOST and REMOTE machines
  - install requirements listed above for each machine
  - clone this repo to HOST.
     - `git clone https://github.com/corpetty/avax-deploy && cd avax-deploy`
  - copy `config.env.example` and `inventory.yml.example` to their names with `example` removed.
     - `cp config.env.example config.env && cp inventory.yml.example inventory.yml`
  - fill in any changes to `config.env`
  - put the public IP of the REMOTE machine in `inventory.yml`
2. run `make step_01_setup_system` on the HOST
  - This step will SSH into the REMOTE machine with credentials provided in the config.env file to:
    - setup the `avax` user and configure its security settings
    - NOTE: the `avax` user is only available via your SSH keyfile of your HOST machine. The password option for SSH is removed.
3. run `make step_02_build_avax_docker_image`
  - this step will build the Statalanche docker image on your HOST machine
4. run `make step_03_docker_build_avax`
  - this step will run the newly built Statalanche docker image and proceed to build Statalanche binaries from scratch. 
  - It places `avalanchego`, and `plugins/evm` binaries into the `build` directory on the HOST machine.
  - NOTE: this step takes a few minutes and can be monitored via the command `docker logs -f <first two characaters of docker image hash>`
5. after you see the two binaries from the previous step in the `build` directory, run `make step_04_build_cert_keys`
  - this step builds the required files to establish TLS connections and derive your Statalanche node's NodeID. These keys _ARE YOUR NODE IDENTITY_, and whatever node runs off these keys is your node. This makes it easier to transport nodes in the event you want to change servers. 
6. run `make step_05_upload_cert_keys`
  - this step uploads your newly created certification keys to the REMOTE machine. 
  - TODO: put into a more secure location for non-testnet scenarios
7. run `make step_06_upload_avax_executables`
  - this step uploads the newly created binaries in the `build` folder to the appropriate place on your REMOTE machine, along with the pre-configured run script `avax_run` for Statalanche. It also makes sure the file permissions are set correctly.
8. run `make step_07_setup_avalanchego`
  - this step configures all the approriate directories required to run Statalanche and setups a systemd service for automating things.
9. run `make step_08_sync_avalanchego`
  - this step starts the systemd service and thus starts the syncing process of Statalanche

