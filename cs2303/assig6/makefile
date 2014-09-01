all: cptest cptest1

cptest: cptest.o
	gcc -g cptest.o -o cptest

cptest1: cptest1.o
	gcc -g cptest1.o -o cptest1

cptest.o: cptest.c
	gcc -c -g cptest.c

cptest1.o: cptest1.c
	gcc -c -g cptest1.c

docs: 
	doxygen
	chmod g+r,o+r html
	cp -p html/* ~/public_html/Systems_Programming/hidden/assig6

clean:
	rm -f *.o
	rm -f cptest
	rm -f cptest1
