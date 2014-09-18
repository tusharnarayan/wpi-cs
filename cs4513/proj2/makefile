all: server dsh

server: server.c
	gcc -g -Wall -o server server.c -lcrypt

dsh: dsh.c
	gcc -g -Wall -o dsh dsh.c -lcrypt

clear_old_files:
	rm -f *.?~
	rm -f \#*#
	rm -f makefile~

clean:
	rm -f *.o
	rm -f server
	rm -f dsh
