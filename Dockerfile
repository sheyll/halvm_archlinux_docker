FROM base/archlinux:latest

# Install make, git, autoconf, ghc, cabal, gcc and Xen 4.4 from AUR. Then
# clone 'master' of HaLVM and build it.
# Finally compile install the HaNS from github.

MAINTAINER Sven Heyll <sven.heyll@gmail.com>

USER root
ENV PATH /opt/halvm/bin:/build/.cabal/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
ENV HOME /build

# Archlinux stuff
ADD pacman.conf /etc/pacman.conf
RUN pacman --noconfirm -Syu; pacman --noconfirm -S yaourt

# Install all the dependencies listed in 'TO_INSTALL'
ADD TO_INSTALL /TO_INSTALL
RUN cat /TO_INSTALL | xargs yaourt --noconfirm -S

# Install HaLVM
WORKDIR /build
RUN git clone https://github.com/GaloisInc/HaLVM.git
WORKDIR /build/HaLVM
RUN git submodule update --init --recursive
RUN autoconf; ./configure --prefix=/opt/halvm --enable-gmp
RUN make
RUN make install

# Remove HaLVM build directory
WORKDIR /build
RUN rm -rf HaLVM

# Install HaNS
WORKDIR /build
RUN git clone https://github.com/GaloisInc/HaNS.git
WORKDIR /build/HaNS
RUN halvm-cabal -j1 install


WORKDIR /build
CMD /usr/bin/bash
