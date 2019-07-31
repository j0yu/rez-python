FROM centos:7

ARG VERSION=3.7.3
ARG INSTALL_DIR=/python

WORKDIR /usr/local/src
RUN mkdir -vp ${INSTALL_DIR}
RUN curl -Ls https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.xz \
    | tar --strip-components=1 -xJ
RUN yum install -y \
        autoconf \
        bluez-libs-devel \
        bzip2 \
        bzip2-devel \
        desktop-file-utils \
        expat-devel \
        findutils \
        gcc-c++ \
        gdb \
        gdbm-devel \
        glibc-devel \
        gmp-devel \
        libappstream-glib \
        libffi-devel \
        libX11-devel \
        ncurses-devel \
        net-tools \
        make \
        openssl-devel \
        pkgconfig \
        readline-devel \
        sqlite-devel \
        systemtap-sdt-devel \
        tar \
        tcl-devel \
        tix-devel \
        tk-devel \
        valgrind-devel \
        xz-devel \
        zlib-devel && \
    yum clean all
RUN autoconf && autoheader && ./configure \
        --prefix=${INSTALL_DIR} \
        --enable-ipv6 \
        --enable-shared \
        --with-computed-gotos=yes \
        --with-dbmliborder=gdbm:ndbm:bdb \
        --with-system-expat \
        --with-system-ffi \
        --enable-optimizations \
        --enable-loadable-sqlite-extensions \
        --with-dtrace \
        --with-valgrind
RUN make --silent -j $(nproc) && make --silent -j $(nproc) install