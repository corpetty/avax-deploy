# Copy config.env.example to config.env and insert the variables values.
# Copy inventory.yml.example to inventory.yml and set your server name.

include config.env

BUILD_DIR=./build
ASSETS_DIR=./assets/cert_keys

AVAX_DOCKER_IMAGE_NAME=avalanchego_builder
AVAX_DOCKER_CONTAINER_NAME=avalanchego_builder

config:
ifndef AVAX_NODE_NAME
	$(error AVAX_NODE_NAME is undefined)
endif

setup_build_folder:
	mkdir -p $(BUILD_DIR)

setup_assets_folder:
	mkdir -p $(ASSETS_DIR)

build_avax_docker_image:
	docker build --no-cache -t $(AVAX_DOCKER_IMAGE_NAME) docker/avalanchego

docker_build_avax: setup_build_folder
	docker run --rm \
		-itd \
		--name $(AVAX_DOCKER_CONTAINER_NAME) \
		-v `pwd`/$(BUILD_DIR):/go/src/github.com/corpetty/avalanchego/build \
		$(AVAX_DOCKER_IMAGE_NAME)

build_cert_keys: setup_assets_folder
	sh ./ansible/avalanchego/files/genCA.sh && \
	  sh ./ansible/avalanchego/files/genStaker.sh

kill_docker_container:
	docker kill $(AVAX_DOCKER_CONTAINER_NAME)

delete_executables:
	ansible-playbook -i inventory.yml -u avax ansible/avalanchego/playbook.yml --tags delete_exec

delete_db:
	ansible-playbook -i inventory.yml -u avax ansible/avalanchego/playbook.yml --tags delete_db

step_01_setup_system: config
	ansible-playbook -i inventory.yml ansible/system/playbook.yml -u $(HOST_USERNAME) --extra-vars "ansible_sudo_pass=$(REMOTE_SUDO_PASS)"

# It builds a docker image used to build avax.
step_02_build_avax_docker_image: config build_avax_docker_image

# It builds avax inside docker.
step_03_docker_build_avax: config docker_build_avax

# It generates avax certification keys if you do not have them already
step_04_build_cert_keys: config build_cert_keys

# It uploads the certification keys
step_05_upload_cert_keys: config
	ansible-playbook -i inventory.yml -u avax ansible/avalanchego/playbook.yml --tags upload_keys

# It uploads the nimbus executable.
step_06_upload_avax_executable: config
	ansible-playbook -i inventory.yml -u avax ansible/avalanchego/playbook.yml --tags upload_exec

# It creates a avax user used to run avalanchego, and the folders in /var/avalanchego-storage/avalanchego.
step_07_setup_avalanchego: config
	ansible-playbook -i inventory.yml -u avax ansible/avalanchego/playbook.yml --tags setup

# It enables the systemd nimbus service.
step_08_sync_avalanchego: config
	ansible-playbook -i inventory.yml -u avax ansible/avalanchego/playbook.yml --tags run