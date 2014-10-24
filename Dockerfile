FROM base/archlinux:latest

# Install make, git, autoconf, ghc, cabal, gcc and Xen 4.4 from AUR. Then
# clone 'master' of HaLVM and build it.

MAINTAINER Sven Heyll <sven.heyll@gmail.com>

USER root

ADD pacman.conf /etc/pacman.conf
RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -S yaourt

ADD TO_INSTALL /TO_INSTALL
RUN cat /TO_INSTALL | xargs yaourt --noconfirm -S

WORKDIR /build
RUN git clone https://github.com/GaloisInc/HaLVM.git

WORKDIR /build/HaLVM
RUN git submodule update --init --recursive
RUN autoconf; ./configure --prefix=/opt/halvm --enable-gmp
RUN make
RUN make install

RUN useradd -m -U user
USER user
WORKDIR /home/user/
ENV PATH /opt/halvm/bin:/home/user/.cabal/bin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
ENV HOME /home/user
RUN halvm-cabal update
CMD /usr/bin/bash
