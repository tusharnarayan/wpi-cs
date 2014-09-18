all: rm_prog dump_prog dive_prog

rm_prog: rm_prog.o
	gcc -g rm_prog.o -o rm_prog

rm_prog.o: rm_prog.c
	gcc -c rm_prog.c

dump_prog: dump_prog.o
	gcc -g dump_prog.o -o dump_prog

dump_prog.o: dump_prog.c
	gcc -c dump_prog.c

dive_prog: dive_prog.o
	gcc -g dive_prog.o -o dive_prog

dive_prog.o: dive_prog.c
	gcc -c dive_prog.c

clean:
	rm -rf rm_prog.o
	rm rm_prog
	rm -rf dump_prog.o
	rm dump_prog
	rm -rf dive_prog.o
	rm dive_prog
