#!/usr/bin/fish
nasm -I include/ -o mbr.bin mbr.S 
nasm -I include/ -o loader.bin loader.S 

dd if=./mbr.bin of=../hd60M.img bs=512 count=1 conv=notrunc
dd if=./loader.bin  of=../hd60M.img bs=512 seek=2 count=4 conv=notrunc
