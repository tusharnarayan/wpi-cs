SHELL := /bin/bash

all: reversestring reversewords

reversestring: reverse.o
	gcc -g reverse.o -o reversestring

reverse.o: reverse.c
	gcc -c -g reverse.c

reversewords: reversestring
	if [ -h reversewords ]; then unlink reversewords; fi
	ln -s reversestring reversewords

clean:
	rm -f *.o reversestring reversewords
