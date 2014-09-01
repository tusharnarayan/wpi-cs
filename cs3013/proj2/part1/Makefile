all: helloworld

helloworld.o: helloworld.c
	gcc -c helloworld.c

helloworld: helloworld.o
	gcc helloworld.o -o helloworld

clean:
	rm -rf helloworld.o helloworld
