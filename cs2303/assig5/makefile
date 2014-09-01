all: stacktest queuetest treetest randomsort

stacktest: stacktest.o stack.o
	gcc -g stacktest.o stack.o -o stacktest

queuetest: queuetest.o queue.o
	gcc -g queuetest.o queue.o -o queuetest

treetest: treetest.o tree.o
	gcc -g treetest.o tree.o -o treetest

randomsort: randomsort.o tree.o
	gcc -g randomsort.o tree.o -o randomsort

stack.o: stack.c stack.h
	gcc -g -c stack.c

queue.o: queue.c queue.h
	gcc -g -c queue.c

tree.o: tree.c tree.h
	gcc -g -c tree.c

stacktest.o: stacktest.c stack.h
	gcc -g -c stacktest.c

queuetest.o: queuetest.c queue.h
	gcc -g -c queuetest.c

treetest.o: treetest.c tree.h
	gcc -g -c treetest.c

randomsort.o: randomsort.c tree.h
	gcc -g -c randomsort.c

docs: 
	doxygen
	chmod g+r,o+r html
	cp -p html/* ~/public_html/Systems_Programming/hidden/assig5

clean:
	rm -f *.o
	rm -f stacktest
	rm -f queuetest
	rm -f treetest
	rm -f randomsort
