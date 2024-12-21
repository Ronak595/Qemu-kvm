#!/bin/bash

# Update package list and install QEMU-KVM and create a raw disk image for windows and Downloads windows iso
echo "Updating package list..."
sudo apt update
sudo apt install -y qemu-kvm unzip cpulimit python3-pip
sudo qemu-img create -f qcow2 /tmp/wi.qcow2 110g
wget -O win.iso "https://archive.org/download/fr_windows_10_multi-edition_vl_version_1709_updated_sept_2017_x86_x64/015%20September%202017/en_windows_10_multi-edition_version_1709_updated_sept_2017_x64_dvd_100090817.iso"
# Launch virtual machine with KVM
echo "Initializing virtual machine..."
echo "VM started successfully please install ngrok yourself and open port 5900"
sudo cpulimit -l 80 -- sudo kvm \
    -cpu host,+topoext,hv_relaxed,hv_spinlocks=0x1fff,hv-passthrough,+pae,+nx,kvm=on,+svm \
   -smp 2,cores=2 \
   -M q35,usb=on \
   -device usb-tablet \
   -m 4G \
   -device virtio-balloon-pci \
   -vga virtio \
   -net nic -net user,hostfwd=tcp::3389-:3389 \
   -boot c \
   -device virtio-serial-pci \
   -device virtio-rng-pci \
   -enable-kvm \
   -cdrom win.iso \
   -hda /tmp/wi.qcow2 \
   -vnc :0
   
