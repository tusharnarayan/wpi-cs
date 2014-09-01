Tushar Narayan
tnarayan@wpi.edu

Description of the programs:

	    queue.c
	    Contains the functions that operate on queues.

	    queuetest.c
	    Contains the main program for testing the functions on queues.

	    randomsort.c
	    Contains the main program for generating random strings,
	    adding to tree, sorting and printing. Also has a secondary
	    function to generate the random strings.

	    stack.c
	    Contains the functions that operate on stacks.

	    stacktest.c
	    Contains the main program for testing the functions on stacks.

	    tree.c
	    Contains the functions that operate on binary trees.

	    treetest.c
	    Contains the main program for testing the functions on trees.    


Instuctions on compiling and linking the program:

	    Files included are queue.c, queuetest.c, 
	    randomsort.c, stack.c, stacktest.c, tree.c, treetest.c,
	    queue.h, stack.h, tree.h, the makefile,
	    and this text file.

	    One needs to put these files in a directory, and 
	    then navigate to that directory from the command
	    line and give the command "make". 
	    (The standard libraries used are included by default.)

	    The makefile has the required instructions to compile 
	    and link all the programs.

	    The programs can be run with the commands './stacktest',
	    './queuetest', './treetest', './randomsort'. 

	    If one needs to remove all the files apart from 
	    the source files, the command "make clean" should be given.
	    Note that this will also remove the output files.
	    
	    To generate the documentation using the Doxygen utility, 
	    the command "make docs" should be given.

	    The documentation can be viewed online at
	    http://users.wpi.edu/~tnarayan/Systems_Programming/hidden/assig5/
