build:
	nasm -f elf64 fizzbuzz.asm
	ld fizzbuzz.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2 -o fizzbuzz

run: build
	./fizzbuzz 101

.PHONY: build run
.DEFAULT_GOAL := run
