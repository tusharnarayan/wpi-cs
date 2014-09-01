ctest: ctest.o mystring.o mystructs.o
	gcc ctest.o mystring.o mystructs.o -o ctest

ctest.o: ctest.c mystring.h mystructs.h
	gcc -c ctest.c

mystring.o: mystring.c mystring.h
	gcc -c mystring.c

mystructs.o: mystructs.c mystructs.h
	gcc -c mystructs.c

docs: 
	doxygen
	chmod g+r,o+r html
	cp -p html/* ~/public_html/Systems_Programming/hidden/assig3

clean: 
	rm -f mystring.o mystructs.o ctest.o ctest

