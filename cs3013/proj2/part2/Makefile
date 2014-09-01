all: helloworld processinfo

helloworld.o: helloworld.c
	gcc -c helloworld.c

helloworld: helloworld.o
	gcc helloworld.o -o helloworld

processinfo.o: processinfo.c
	gcc -c processinfo.c

processinfo: processinfo.o
	gcc processinfo.o -o processinfo

clean:
	rm -rf helloworld.o helloworld
	rm -rf processinfo.o processinfo
