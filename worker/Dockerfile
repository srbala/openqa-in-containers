FROM fedora:36
LABEL maintainer Jan Sedlak <jsedlak@redhat.com>, Josef Skladanka <jskladan@redhat.com>, Bala Raman <srbala@gmail.com>

RUN dnf install -y openqa-worker \
    edk2-ovmf \
    guestfs-tools \
    libguestfs-xfs \
    libvirt-daemon-config-network \
    perl-REST-Client \
    python3-libguestfs \
    virt-install \
    ca-certificates \
    curl \
    gzip \
    rsync \
    ipxe-roms-qemu \
    sudo \
    withlock && dnf clean all; \
    groupmod -g 701 _openqa-worker; \ 
    groupadd -g 700 geekotest; \
    usermod -u 701 _openqa-worker; \
    (dnf install -y kmod qemu-kvm libvirt-daemon-driver-qemu edk2-ovmf qemu-tools qemu-device-display-virtio-gpu qemu-device-display-virtio-gpu-ccw qemu-device-display-virtio-gpu-gl qemu-device-display-virtio-gpu-pci qemu-device-display-virtio-gpu-pci-gl ||:) && \
    (dnf install -y edk2-aarch64 ||:) && \
    dnf clean all && \
    mkdir -p /root/qemu

COPY kvm-mknod.sh /root/qemu/kvm-mknod.sh
COPY run_openqa_worker.sh /run_openqa_worker.sh
# ensure executability in case we loose file permissions, e.g. within open
# build service when downloading files into the container build project
RUN chmod +x /root/qemu/kvm-mknod.sh && \
    chmod a+x /run_openqa_worker.sh && \
    # set-up shared data and configuration
    mkdir -p /data/factory /data/tests /data/conf && \
    rm -rf /etc/openqa/client.conf /etc/openqa/workers.ini && \
    mkdir -p /var/lib/openqa/share && \
    ln -s /data/conf/client.conf /etc/openqa/client.conf && \
    ln -s /data/conf/workers.ini /etc/openqa/workers.ini && \
    ln -s /data/factory /var/lib/openqa/share/factory && \
    ln -s /data/tests /var/lib/openqa/share/tests && \
    # set proper ownership and file modes
    chown -R _openqa-worker /usr/share/openqa/script/worker /var/lib/openqa/cache /var/lib/openqa/pool && \
    chmod -R ug+rw /usr/share/openqa/script/worker /var/lib/openqa/cache /var/lib/openqa/pool && \
    find /usr/share/openqa/script/worker /var/lib/openqa/cache /var/lib/openqa/pool -type d -exec chmod ug+x {} \;

ENTRYPOINT ["/run_openqa_worker.sh"]