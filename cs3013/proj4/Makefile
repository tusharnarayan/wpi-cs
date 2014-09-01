all: malloc.o test_malloc

malloc.o: malloc.c malloc.h
	gcc -c malloc.c

test_malloc.o: test_malloc.c
	gcc -c test_malloc.c 

test_malloc: test_malloc.o  malloc.o
	gcc test_malloc.o malloc.o -o test_malloc

clean:
	rm -rf malloc.o
	rm -rf test_malloc.o test_malloc
