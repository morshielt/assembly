PROGRAMS = euronmain euron

euron: euronmain.c euron.o
	gcc -DN=1 -pthread -no-pie -o euron euronmain.c euron.o
%.o: %.asm
	nasm -DN=1 -f elf64 -F dwarf -g $<