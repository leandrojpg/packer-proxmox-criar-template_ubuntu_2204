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
  storage:
      swap:
          size: 0
      layout:
          name: lvm
  identity:
      username: "ubuntu"
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
      - qemu-guest-agent
  late-commands:
    - sed -i -e 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/g' /target/etc/ssh/sshd_config
    - echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /target/etc/sudoers.d/ubuntu
    - curtin in-target --target=/target -- chmod 440 /etc/sudoers.d/ubuntu
    - curtin in-target --target=/target -- systemctl enable qemu-guest-agent
