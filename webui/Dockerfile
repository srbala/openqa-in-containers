FROM fedora:36
LABEL AUTHOR="Bala Raman <srbala@gmail.com>" 
RUN dnf install -y \
# TODO: need to revisit to optmize for better package
# openqa-bootstrap vs openqa-single-instance or standard
#    openqa \ 
#    openqa-httpd \
    openqa-local-db \
    git \
    mod_ssl \
    nfs-utils \
    perl-REST-Client \
    python3-jsonschema \
    withlock \
    liboauth2 \
    liboauth2-apache \
    perl-Mojolicious-Plugin-OAuth2 \
    vim-minimal \
    nano \
    fedora-messaging \
    guestfs-tools \
    libguestfs-xfs \
    python3-fedfind \
    python3-libguestfs \
    python3-pip \
    python3-openqa_client \
    openqa-python-scripts \
    libvirt-daemon-config-network \
    virt-install \
    tini && \
    dnf clean all && \
    pip install --no-cache-dir pytest pytest-testinfra tox && \
    groupmod -g 700 geekotest; \ 
    groupadd -g 701  _openqa-worker; \
    usermod -u 700 geekotest; 

COPY openqa-ssl.conf /etc/apache2/vhosts.d/openqa-ssl.conf
COPY openqa.conf /etc/apache2/vhosts.d/openqa.conf
COPY run_openqa.sh /root/

# set-up shared data and configuration
RUN rm -rf /etc/openqa/openqa.ini /etc/openqa/client.conf \
      /etc/openqa/database.ini \
      /var/lib/openqa/share/factory /var/lib/openqa/share/tests \
      /var/lib/openqa/testresults /var/lib/openqa/images && \
    chmod +x /root/run_openqa.sh && \
    usermod -aG kvm,qemu,libvirt geekotest && \
    mkdir -p /var/lib/openqa/pool /var/log/openqa && \
    ln -s /data/conf/openqa.ini /etc/openqa/openqa.ini && \
    ln -s /data/conf/database.ini /etc/openqa/database.ini && \
    ln -s /data/conf/client.conf /etc/openqa/client.conf && \
    ln -s /data/factory /var/lib/openqa/share/factory && \
    ln -s /data/tests /var/lib/openqa/share/tests && \
    ln -s /data/testresults /var/lib/openqa/testresults && \
    ln -s /data/images /var/lib/openqa/images && \
    chown -R geekotest /usr/share/openqa /var/lib/openqa /var/log/openqa && \
    chmod ug+rw /usr/share/openqa /var/lib/openqa /var/log/openqa && \
    find /usr/share/openqa /var/lib/openqa /var/log/openqa -type d -exec chmod ug+x {} \;

EXPOSE 80 443 9526 9527 9528 9529
CMD ["/root/run_openqa.sh"]