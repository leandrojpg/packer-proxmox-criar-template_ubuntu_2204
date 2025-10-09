packer {
  required_plugins {
    proxmox = {
      source  = "github.com/hashicorp/proxmox"
      version = "= 1.1.3"
    }
  }
}

variable "image_name" {
  type    = string
  default = "ubuntu-2204-template"
}

variable "template_so_username" {
  type    = string
  default = "ubuntu"
}

variable "template_so_password" {
  type    = string
  default = "ubuntu@123"
}

variable "template_so_password_hash" {
  type    = string
  default = "$y$j9T$.VCZGWfaBMLXcP5Wwdur./$CLiUaf3vrOLl.3FR318JAcnrUKhUyb8SpFzTHWwk6nC"
}

locals {
  data_source_content = {
    "/meta-data" = file("${abspath(path.root)}/data/meta-data")
    "/user-data" = templatefile("${abspath(path.root)}/data/user-data.pkrtpl.hcl", {
      username = var.template_so_username
      password = var.template_so_password_hash
    })
  }
}

source "proxmox-iso" "ubuntu-template" {
  # Configuração de conexão
  proxmox_url = "https://192.168.18.31:8006/api2/json"
  username    = "root@pam"
  password    = "Brasil.123"
  insecure_skip_tls_verify = true

  # Configuração da VM
  node                 = "proxmox"
  vm_id                = 9000
  vm_name              = "${var.image_name}"
  template_description = "Ubuntu 22.04 Template created with Packer"

  # Recursos
  cores  = 2
  memory = 2048

  # Disco
  disks {
    disk_size    = "40G"
    storage_pool = "local-lvm"
    type         = "scsi"
    format       = "raw"
  }

  # Rede
  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # ISO
  iso_url          = "https://storage.googleapis.com/opscenter-isos/releases/22.04/release/ubuntu-22.04.5-live-server-amd64.iso"
  iso_checksum     = "sha256:9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
  iso_storage_pool = "local"

  # Cloud-Init
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  # Configuração de boot
  boot_wait = "10s"
  boot_command = [
    "<wait10s>",
    "c<wait>",
    "linux /casper/vmlinuz --- autoinstall ds=\"nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/\"<enter>",
    "<wait2s>",
    "initrd /casper/initrd<enter>",
    "<wait2s>",
    "boot<enter>"
  ]

  # HTTP server para cloud-init
  http_content = local.data_source_content
  http_port_min = 8080
  http_port_max = 8080

  # SSH
  ssh_username = "ubuntu"
  ssh_password = "ubuntu@123"
  ssh_timeout  = "30m"
  ssh_handshake_attempts = 100

  # Template - O Proxmox converte automaticamente quando template_name é definido
  template_name = "${var.image_name}"
}

build {
  sources = ["source.proxmox-iso.ubuntu-template"]

  # EVITAR REINÍCIOS DURANTE A INSTALAÇÃO
  provisioner "shell" {
    inline = [
      "set -eu",
      "sudo apt update",
      # Configurar needrestart para não reiniciar automaticamente
      "sudo sed -i 's/#$nrconf{restart} = 'i';/$nrconf{restart} = 'a';/g' /etc/needrestart/needrestart.conf || true",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -o Dpkg::Options::=\"--force-confold\""
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive"
    ]
    inline = [
      "sudo apt-add-repository -y ppa:maas/3.5",
      "sudo apt update",
      "sudo apt install -y build-essential qemu-guest-agent git jq python3-pip unzip zip python3-openssl software-properties-common",
      "sudo pip install ansible"
    ]
  }

  # PROVISIONER FINAL - PREPARAR PARA TEMPLATE
  provisioner "shell" {
    inline = [
      # Parar serviços que podem interferir
      "sudo systemctl stop qemu-guest-agent || true",
      "sudo systemctl stop systemd-timesyncd || true",
      
      # Limpeza final
      "sudo rm -f /etc/netplan/*.yaml",
      "sudo rm -f /etc/ssh/ssh_host_*",
      "sudo truncate -s0 /etc/machine-id",
      "sudo rm -f /var/lib/dbus/machine-id",
      "sudo ln -s /etc/machine-id /var/lib/dbus/machine-id",
      
      # Limpar logs e cache
      "sudo cloud-init clean --logs",
      "sudo apt autoremove -y",
      "sudo apt clean",
      "sudo journalctl --rotate || true",
      "sudo journalctl --vacuum-time=1s || true",
      
      # Limpar histórico
      "sudo rm -f /root/.bash_history",
      "sudo rm -f /home/ubuntu/.bash_history",
      
      # Garantir que o SSH vai funcionar após o reboot
      "sudo dpkg-reconfigure openssh-server",
      
      # Mensagem final
      "echo 'Packer build complete - VM will be converted to template'"
    ]
  }

  # PROVISIONER PARA CONVERTER EM TEMPLATE (via API Proxmox)
  provisioner "shell" {
    execute_command = "echo 'Converting to template...'"
    inline = [
      "echo 'VM ready for template conversion'"
    ]
  }
}
