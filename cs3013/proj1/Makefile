all: runCommand shell shell2

runCommand.o: runCommand.c
	gcc -c runCommand.c

shell.o: shell.c
	gcc -c shell.c

shell2.o: shell2.c
	gcc -c shell2.c

runCommand: runCommand.o
	gcc runCommand.o -o runCommand

shell: shell.o
	gcc shell.o -o shell

shell2: shell2.o
	gcc shell2.o -o shell2

clean:
	rm -f runCommand.o shell.o shell2.o runCommand shell shell2