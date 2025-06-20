#!/bin/bash

ISO_DIR="~/os-isos"

usage() {
    echo "Usage: $0 /dev/sdX"
    echo "Example: $0 /dev/sda"
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

USB_DEVICE="$1"

# Collect available ISOs
ISO_PATH=$(find ~/os-isos -maxdepth 1 -type f -name "*.iso" | fzf --prompt="Select the ISO to flash: ")

if [ -z "$ISO_PATH" ]; then
    echo "No ISO selected. Aborted."
    exit 3
fi

echo "You are about to completely erase and write $ISO_PATH to $USB_DEVICE."
read -p "Are you sure you want to continue? This will erase all data on $USB_DEVICE! (y/N): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "Aborted."
    exit 2
fi

echo "Unmounting $USB_DEVICE..."
sudo umount ${USB_DEVICE}*

echo "Wiping $USB_DEVICE with zeros..."
sudo dd if=/dev/zero of="$USB_DEVICE" bs=64M status=progress oflag=sync

echo "Writing $ISO_PATH to $USB_DEVICE..."
sudo dd if="$ISO_PATH" of="$USB_DEVICE" bs=4M status=progress oflag=sync

echo "Ejecting $USB_DEVICE..."
sudo eject "$USB_DEVICE"

echo "Done. $USB_DEVICE is now a bootable USB stick with $ISO_PATH, and all old data has been erased."
