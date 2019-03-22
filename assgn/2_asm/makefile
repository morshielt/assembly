PROGRAMS = euronmain euron

euron: euronmain.c euron.o
	gcc -DN=2 -pthread -o euron euronmain.c euron.o
%.o: %.asm
	nasm -DN=2 -f elf64 -F dwarf -g $<