#!/bin/bash

# Update package list and install QEMU-KVM and create a raw disk image for windows and Downloads windows iso
echo "Updating package list..."
sudo apt update
sudo apt install -y qemu-kvm unzip cpulimit python3-pip
sudo qemu-img create -f qcow2 /tmp/wi.qcow2 110g
wget -O win.iso "https://software.download.prss.microsoft.com/dbazure/Win10_22H2_English_x32v1.iso?t=0f74118d-105b-4701-8a79-18eb1daeb85e&P1=1734783089&P2=601&P3=2&P4=bB6F1oKSA%2fewisg6wbK4pyAZyxXre2ogMuXS9TbhTGcIoiSDTKHmPvRumRCFbhtcUm6tRHH%2fjX6CoCU2bY2Lo5k3%2b0dz%2bGTZjtQRGCO6jUvxU1lxB4eVPHQPeEce7cfzbVRiZVYLDJsJ58VGw9hglWB9hYo%2fIcpa3zrDoZNLWJypa6RgOaHURTy8Oul2vo4l0DbzujZ%2biEX3gWaEBie0OTqi6czpNeoyV1MdXu0DP9yjELqHcUhN8kmbpcWrLHJlpowsHriMWeGNINuNLhUj%2fkJD2sWqXobH%2b%2beDupCt9VOONXpcVo%2bvOcI%2foPPQ258SQqau2zhN%2b156adi5qoVP7Q%3d%3d"
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
   
