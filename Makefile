all: bootx64.efi

genpack:
	genpack

bootx64.efi: genpack
	unsquashfs -f -no-xattrs one-file-linux-x86_64.squashfs efi/boot/bootx64.efi
	mv squashfs-root/efi/boot/bootx64.efi $@
	dd if=one-file-linux-x86_64.squashfs of=$@ seek=1 bs=1M
	rm -rf squashfs-root

clean:
	rm -f one-file-linux-x86_64.squashfs bootx64.efi
