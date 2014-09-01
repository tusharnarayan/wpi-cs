all: assig1

assig1.o: assig1.c calculatestats.h
	gcc -c assig1.c
calculatestats.o: calculatestats.c calculatestats.h
	gcc -c calculatestats.c
assig1: assig1.o calculatestats.o
	gcc assig1.o calculatestats.o -o assig1
