all: Server Browser

Server: server.c
	gcc -pthread -o Server server.c

Browser: client.c
	gcc -o Browser -g client.c

clear_old_files:
	rm -f *.?~
	rm -f \#*#
	rm -f makefile~

clean:
	rm -f *.o
	rm -f Browser
	rm -f Server
