all: stest myarrays myfiles binaryarrays

stest: stest.o mystructs.o
	gcc -g stest.o mystructs.o -lreadline -lncurses -o stest

myarrays: myarrays.o mystructs.o
	gcc -g myarrays.o mystructs.o -lreadline -lncurses -o myarrays

myfiles: myfiles.o mystructs.o
	gcc -g myfiles.o mystructs.o -lreadline -lncurses -o myfiles

binaryarrays: binaryarrays.o
	gcc -g binaryarrays.o -lreadline -lncurses -o binaryarrays

stest.o: stest.c mystructs.h
	gcc -g -c stest.c

mystructs.o: mystructs.c mystructs.h
	gcc -g -c mystructs.c

myarrays.o: myarrays.c mystructs.h
	gcc -g -c myarrays.c

myfiles.o: myfiles.c mystructs.h
	gcc -g -c myfiles.c

binaryarrays.o: binaryarrays.c
	gcc -g -c binaryarrays.c

docs: 
	doxygen
	chmod g+r,o+r html
	cp -p html/* ~/public_html/Systems_Programming/hidden/assig4

debug:
	gcc -g -c stest.c
	gcc -g -c mystructs.c
	gcc -g stest.o mystructs.o -lreadline -lncurses -o stest

debugplus:
	gcc -g -c stest.c
	gcc -DDEBUG=10 -g -c mystructs.c
	gcc -g stest.o mystructs.o -lreadline -lncurses -o stest

clean: 
	rm -f *.o
	rm -f stest.txt stest
	rm -f myarrays.txt myarrays
	rm -f myfiles
	rm -f binaryarrays.bin binaryarrays
