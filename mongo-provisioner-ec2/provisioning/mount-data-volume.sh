#!/bin/bash

set -x

devpath=$(readlink -f /dev/xvdh)

sudo file -s $devpath | grep -q ext4
if [[ 1 == $? && -b $devpath ]]; then
  sudo mkfs -t ext4 $devpath
fi

sudo mkdir -p /mongodata
sudo chmod -R 0775 /mongodata

echo "$devpath /mongodata ext4 defaults,nofail,noatime,nodiratime,barrier=0,data=writeback 0 2" | sudo tee -a /etc/fstab > /dev/null
sudo mount /mongodata

# TODO: /etc/rc3.d/S99local to maintain on reboot
echo deadline | sudo tee /sys/block/$(basename "$devpath")/queue/scheduler
echo never | sudo tee /sys/kernel/mm/transparent_hugepage/enabled