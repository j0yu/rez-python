FROM centos:7

RUN yum install -y yum-utils make \
    && yum-builddep -y python3 \
    && yum clean all
WORKDIR /usr/local/src
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]