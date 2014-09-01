Tushar Narayan
tnarayan@wpi.edu

Description of the programs:

	    at.c:
	    The program at.c creates and fills an array of integers 
	    and an array of doubles, and then prints both these arrays.

	    at2.c:
	    The program at2.c asks the user for an array of integers, 
	    prints the array, then sorts the array and prints it again.

	    at3.c
	    The program at3.c generates an array of random integers and 
	    prints it, then sorts it and prints it again.

Notes on the functions:
      
      The BubbleSort algorithm is used for sorting all the arrays.

      The file array_functions.c has secondary functions that operate 
      on the arrays (sort and generate random array).
      The function for generating a random array itself 
      uses a helper function for generating random numbers.
      The file array_functions.h has the prototypes for all these functions.

      The makefile has the instructions for making all these programs.

      The file print_arrays.c has secondary functions for printing arrays of 
      both integers and doubles.
      It also has a function for taking in integers from the user 
      for array input.
      The file print_arrays.h has the prototypes for these functions.


Instuctions on compiling and linking the program:

	    Files included are array_functions.c, array_functions.h, 
	    at.c, at2.c, at3.c, the makefile, print_arrays.c, 
	    print_arrays.h, and this text file.
	    One needs to put these files in a directory, and 
	    then navigate to that directory from the command
	    line and give the command "make". 
	    (The standard libraries used are included by default.)

	    The makefile has the required instructions to compile 
	    and link all the programs.

	    The files can then be run by the commands 
	    "./at.c", "./at2.c", and "./at3.c".

	    If one needs to remove all the files apart from 
	    the source files, the command "make clean" should be given.
	    
	    To generate the documentation using the Doxygen utility, 
	    the command "make docs" should be given.

	    The documentation can be viewed online at
	    http://users.wpi.edu/~tnarayan/assig2/
