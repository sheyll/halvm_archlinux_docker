#
# Archlinux HaLVM Installation in a Docker Container
# ==================================================
#
# Create a docker container with an HaLVM installation in /opt/halvm.
#
# NOTE: Docker must be installed and the current user must be privileged to
#       use docker.
#

# Create a docker container from a docker image with HaLVM installed:
.PHONY: image
container: clean-container image
	docker create -i -t --name halvm-archlinux halvm/archlinux:latest

# Start a shell inside the finished container:
.PHONY: run
run:
	docker start -a -i halvm-archlinux

# Install all build dependencies and build HaLVM into a docker container:
.PHONY: image
image: Dockerfile TO_INSTALL pacman.conf
	docker pull base/archlinux
	docker build -t halvm/archlinux . | tee build.log

# Remove the docker container, but not the image:
.PHONY: clean-container
clean-container:
	-docker rm halvm-archlinux

# Remove the docker container AND image:
.PHONY: clean-image
clean-image: clean-container
	-rm build.log
	-docker rmi halvm/archlinux:latest
