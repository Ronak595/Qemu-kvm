#!/bin/bash

# Update package list and install QEMU-KVM and create a raw disk image for windows and Downloads windows iso
echo "Updating package list..."
sudo apt update
sudo apt install -y qemu-kvm unzip cpulimit python3-pip
sudo qemu-img create -f qcow2 /tmp/wi.qcow2 110g
wget -O win.iso "https://software.download.prss.microsoft.com/dbazure/Win10_22H2_English_x64v1.iso?t=7984020e-e88e-4e19-9a76-85bbd937b5d7&P1=1734271537&P2=601&P3=2&P4=Mi3M%2b5vY9JVXEf6TFOz0hadTRrWj53aRbCi8MqHrZlzBx1Zr5Vvyss6lHR7ZQhfJ%2bSe5EpsbwYoDc98r5wx7D3qWqy1HBEF%2fdVBEdQBJxRuxeCxG%2f0pCP75eFoVl9DiJLaoXx0Z0OkwFUIr7Yqhh81KJ9lRiG2AT878V8jALtaqMz3AbZgLgbeVEjYr0tXSoXHaton%2fpBLxfdH6oOzrpv7D%2bwPdbMqvjzpIrj2H%2bdn8QQpg4sMBvnM6hryVABglDfmQKVDwMUYxfznOl3KF9EsT%2bYGmCWvymsqrBiuWFVtW2Uvxyc62FlOk66EB%2f3Wimzi%2fmFBsGWrBGm6%2fMujwkJg%3d%3d"

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
   
