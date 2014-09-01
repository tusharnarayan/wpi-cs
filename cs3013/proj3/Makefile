all: phase1 phase2

phase1.o: phase1.c
	gcc -c phase1.c -pthread

phase1: phase1.o
	gcc phase1.o -o phase1 -pthread

phase2.o: phase2.c
	gcc -c phase2.c -pthread

phase2: phase2.o
	gcc phase2.o -o phase2 -pthread

clean:
	rm -rf phase1.o phase1
	rm -rf phase2.o phase2
