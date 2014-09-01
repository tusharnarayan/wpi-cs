Tushar Narayan
tnarayan@wpi.edu

Description of the program:

The program calculates the average of the grades that the user inputs into it.

It stores the grades in a single-dimensional array and calls a function that
calculates the average, the minimum, and the maximum of that array; and prints the result.

The program regulates the entry in two ways:
 1) either the user can keep entering grades till she hits the upper limit of the array (MAX_GRADES)
 2) the user signals end of input by entering in a negative grade
    (this negative grade does not affect the arithmetic of the average)
	
The program also considers a grade to be valid only if it is a positive number equal to or less than
100. If not, the user is printed an error message and asked to reenter a valid grade.

The number of valid grades entered are kept track of, and used to calculate the average.


Instuctions on compiling and linking the program:

Files included are assig1.c, calculatestats.c, calculatestats.h, the makefile, and this text file.
One needs to put these files in a directory, and then navigate to that directory from the command
line and give the command "make". (The standard library stdio.h should be included by default.)

The makefile has the required instructions for the computer to compile and link this program.

The file can then be run by the command "./assig1.c".