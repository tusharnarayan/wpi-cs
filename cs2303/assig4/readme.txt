Tushar Narayan
tnarayan@wpi.edu

Description of the programs:

	    binaryarrays.c
	    Contains the main program and functions for storing structs
	    in binary files, and for reading and printing structs
	    from binary files.

	    myarrays.c:
	    Contains the main program and functions for taking in
	    user input for an array of structs, and writing the array
	    to a text file.

	    myfiles.c
	    Contains the main program and functions for reading array
	    of structs from a text file, and then printing the structs.

	    mystructs.c
	    Contains functions that act on structs of Employees.

	    stest.c
	    Contains main program for writing employee structs to file,
	    and printing them.	    


Instuctions on compiling and linking the program:

	    Files included are stest.c, myarrays.c, 
	    mystructs.c, myfiles.c, binaryarrays.c, mystructs.h, the makefile,
	    and this text file.

	    One needs to put these files in a directory, and 
	    then navigate to that directory from the command
	    line and give the command "make". 
	    (The standard libraries used are included by default.)

	    The makefile has the required instructions to compile 
	    and link all the programs.
	    The command 'make debugplus' does the compilation with the
	    DEBUG symbol defined.

	    The programs can be run with the commands './stest',
	    './myarrays', './myfiles', './binaryarrays'. 

	    If one needs to remove all the files apart from 
	    the source files, the command "make clean" should be given.
	    Note that this will also remove the output files.
	    
	    To generate the documentation using the Doxygen utility, 
	    the command "make docs" should be given.

	    The documentation can be viewed online at
	    http://users.wpi.edu/~tnarayan/Systems_Programming/hidden/assig4/
