readlinetest: readlinetest.o
	gcc -g readlinetest.o -lreadline -lncurses -o readlinetest

readlinetest.o: readlinetest.c
	gcc -g -c readlinetest.c

clean:
	rm -f *.o readlinetest
