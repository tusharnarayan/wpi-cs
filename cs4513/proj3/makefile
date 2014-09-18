#
# Makefile
# Adapted from http://web.cs.wpi.edu/~cs4513/d14/samples/mcast.tar
# (folder: mcast/mcast/makefile)
#

LIB = ncurses
CC = gcc

all: mcast

mcast: mcast.c msock.o msock.h listener.o listener.h
	$(CC) -o mcast mcast.c msock.o listener.o

listener: listener.c listener.h
	$(CC) -Wall -c listener.c

msock: msock.c msock.h
	$(CC) -Wall -c msock.c

clean:
	/bin/rm -rf mcast *.o *~
