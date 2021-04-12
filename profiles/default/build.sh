#!/bin/sh
set -e

build-kernel

emerge -uDN -bk --binpkg-respect-use=y --exclude='sys-kernel/*' world @all

mkdir -p /tmp/initramfs

cat << EOS > /tmp/initramfs.lst
bin/cat
bin/cp
bin/umount
lib64/libattr.so.1
lib64/libc.so.6
lib64/ld-linux-x86-64.so.2
lib64/libblkid.so.1
lib64/libuuid.so.1
lib64/libmount.so.1
lib64/librt.so.1
lib64/libpthread.so.0
lib64/liblzo2.so.2
lib64/libsmartcols.so.1
lib64/libz.so.1
lib64/libdevmapper-event.so.1.02
lib64/libdl.so.2
lib64/libdevmapper.so.1.02
lib64/libaio.so.1
lib64/libm.so.6
sbin/btrfs
sbin/switch_root
sbin/mkfs.btrfs
sbin/mkswap
sbin/swapon
sbin/lvm
sbin/vgchange
usr/lib64/libiniparser4.so.1
usr/lib64/libzstd.so.1
EOS

mkdir -p /tmp/initramfs/usr/lib64
gcc -lblkid -lmount -liniparser4 /init.c -o //tmp/initramfs/init

tar cf - -C / -T /tmp/initramfs.lst -h | tar xvf - -C /tmp/initramfs
rm -f /boot/initramfs
cd /tmp/initramfs && find . | cpio -H newc -o > /boot/initramfs

