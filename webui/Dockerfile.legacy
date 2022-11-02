FROM fedora:25
MAINTAINER Jan Sedlak <jsedlak@redhat.com>, Josef Skladanka <jskladan@redhat.com>

RUN dnf install -y openqa openqa-httpd && dnf clean all

# /var/lib/openqa/share should be mounted from outside
ADD run_openqa.sh /root/
ADD openqa.ini /etc/openqa/openqa.ini
RUN chmod +x /root/run_openqa.sh && \
    mkdir -p /run/dbus && \
    cp /etc/httpd/conf.d/openqa.conf.template /etc/httpd/conf.d/openqa.conf

EXPOSE 80
CMD ["/root/run_openqa.sh"]
