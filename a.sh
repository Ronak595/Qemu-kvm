#!/bin/bash

# Update package list and install QEMU-KVM and create a raw disk image for windows and Downloads windows iso
echo "Updating package list..."
sudo apt update
sudo apt install -y qemu-kvm unzip cpulimit python3-pip
sudo qemu-img create -f qcow2 /tmp/wi.qcow2 110g
wget -O win.iso "https://software.download.prss.microsoft.com/dbazure/Win10_22H2_English_x32v1.iso?t=6ef34c65-35a6-4e75-8da9-51317da3d5b8&P1=1734678539&P2=601&P3=2&P4=dq%2fc3TCRCM1Av7Hvdt%2br3C3wF4V1%2fTFA8QbkiBTgu%2f9LtqxLWOs%2fyYlAc5E1eiT%2bl6LpmFeSf7JqOsZel148JnPLfm0%2bfSgK7gTWF1jISxk956lEOLYOohiK7MLyVruotw0LIARMpACH9nt6C9K2vubUNFq7ib%2b6q5ChIzzUeXLXs3RqWuQHldkV%2ba%2fPmZC1eQcBffyx806c48xG0fEQ%2bs3yAuW%2bZHflRZ%2bh6zFcZsU6J9EkDjkejRyt2cUQA4C4nbR8I4LpN3JKj0dWisFB9LF5hsoUv8VRLVxVNIJXdtiRgcabu5qrqZW2sAYX%2fc62mTm0A4jN79XpdJOJ2upE9Q%3d%3d"

fi

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
    -net nic,netdev=n0,model=virtio-net-pci \
    -netdev user,id=n0,hostfwd=tcp::3389-:3389 \
    -boot c \
    -device virtio-serial-pci \
    -device virtio-rng-pci \
    -enable-kvm \
    -cdrom win.iso \
    -hdd /tmp/wi.qcow2 \
    -vnc :0
   
