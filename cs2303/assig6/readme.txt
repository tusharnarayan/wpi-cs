Tushar Narayan
tnarayan@wpi.edu

Description of the programs:
	  
	  cptest.c
	  Takes single file inputs and a directory or output file to copy to.
	  Also takes in copy function option and buffer size.
	  Returns appropriate message, timestamps before and after copying,
	  and duration of copying.

	  cptest1.c
	  Takes command line inputs for copy function option and buffer size.
	  Takes multiple input files and a directory to copy to,
	  or takes a single input file and a path to the file to copy to.
	  Returns appropriate message for each of the files that it attempts
	  to copy, with the timestamps and duration of copying for each.

I completed all sections of Part B.

Instructions on compiling and linking the program:

	     Files included are cptest.c, cptest1.c, the makefile, and this
	     text file.
	     
	     One needs to put these files in a directory, and 
	     then navigate to that directory from the command
	     line and give the command "make". 
	     (The standard libraries used are included by default.)

	     The makefile has the required instructions to compile 
	     and link all the programs.

	     The programs can be run with the commands './cptest', and
	     './cptest1'.

	     If one needs to remove all the files apart from 
	     the source files, the command "make clean" should be given.
	     Note that this will also remove the output files.
	     
	     To generate the documentation using the Doxygen utility, 
	     the command "make docs" should be given.

	     The documentation can be viewed online at
	     http://users.wpi.edu/~tnarayan/Systems_Programming/hidden/assig6/

Section B, Part 3 Results:
Timing Test Results and Conclusions reached

Note that in the following table, the infile and the outfile used were the
same each time. The infile was well within the default buffer size of 1024
bytes.

Command	Run				Copying Function Used		Time
./cptest infile outfile			default (1)			0.007s
./cptest infile outfile 1		1				0.005s
./cptest infile outfile 2		2				0.019s
./cptest infile outfile	3		3 - default buffer size (1024)	0.010s
./cptest infile outfile	3 1024		3 - buffer size of 1024		0.005s
./cptest infile outfile 3 10655		3 - buffer size of 10655	0.006s
./cptest infile outfile 3 230099	3 - buffer size of 230099	0.010s

From these test times, it can be seen that copyfile3 (using a buffer) is the
most efficient file copying function, followed by copyfile1 (formatted I/O),
while copyfile2 (unformatted I/O) is the least efficient. However, it is
interesting to note that these run-time durations changed significantly 
with the time of the day that the program was tested 
(for example, copyfile1 took 0.040s once. I would say that this difference was
due to fluctuations in my internet connection and also on the number of clients
running on the CCC server; along with the program/memory loading time 
fluctuation.) With that said, the difference between the program run times
stayed approximately the same, proving that copyfile3 is indeed the most
efficient, and copyfile2 is the least.

In copyfile3, the buffer size of 1024 seems quite efficient. However, the tests
with the time command were rather inconclusive (in one case, I got 0.005s for
any of the buffer sizes of 20, 200, 2000, 20000, and 20000000).
