#
# Archlinux HaLVM Installation in a Docker Container
# ==================================================
#
# Create a docker container with an HaLVM installation in /opt/halvm.
#
# NOTE: Docker must be installed and the current user must be privileged to
#       use docker.
#

.PHONY: build
# Install all build dependencies and build HaLVM.
build: image Dockerfile TO_INSTALL pacman.conf
	docker build --rm=false -t halvm/archlinux . | tee build.log

.PHONY: image
# Pull the Archlinux base image.
image:
	docker pull base/archlinux
