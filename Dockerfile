FROM CentOS:7
MAINTAINER Stacy Webb <stacy.webb@pwc.com>

ENV VERSION 2.0.5

RUN yum update && \
    yum install -y wget mysql-client inotify-tools procps && \
    wget https://github.com/sysown/proxysql/releases/download/v${VERSION}/proxysql-${VERSION}-1-centos7.x86_64.rpm -O /opt/proxysql-${VERSION}-1-centos7.x86_64.rpm && \
    yum localinstall /opt/proxysql-${VERSION}-1-centos7.x86_64.rpm && \
    rm -f /opt/proxysql-${VERSION}-1-centos7.x86_64.rpm

VOLUME /var/lib/proxysql
EXPOSE 6032 6033 6080

COPY entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
