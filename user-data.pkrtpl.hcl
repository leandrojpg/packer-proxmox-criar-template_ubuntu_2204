#cloud-config
autoinstall:
  version: 1
  locale: en_US.UTF-8
  refresh-installer:
    update: yes
  keyboard:
    layout: us
  apt:
    primary:
      - arches: [default]
        uri: http://archive.ubuntu.com/ubuntu/
  network:
    version: 2
    ethernets:
      ens18:
        dhcp4: true
  storage:
    swap:
      size: 0
    layout:
      name: lvm
  identity:
    username: "${username}"
    hostname: ubuntu.localdomain
    password: "$y$j9T$.VCZGWfaBMLXcP5Wwdur./$CLiUaf3vrOLl.3FR318JAcnrUKhUyb8SpFzTHWwk6nC"
  ssh:
    install-server: yes
    authorized-keys: []
    allow-pw: yes
  user-data:
    disable_root: false
  packages:
    - ca-certificates
    - cloud-init
    - openssh-server  # Ensure SSH server is installed
  late-commands:
    - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
    - echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/ubuntu
    - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/ubuntu
    - curtin in-target -- apt-get update
    - curtin in-target -- apt-get install -y qemu-guest-agent
    - curtin in-target --target=/target -- systemctl enable qemu-guest-agent
    - curtin in-target --target=/target -- systemctl enable ssh
    - curtin in-target --target=/target -- bash -c 'echo "Cloud-init debug" > /root/cloud-init-debug.log'
