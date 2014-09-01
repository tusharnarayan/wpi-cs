Project 1
tnarayan Tushar Narayan
cerogers Cynthia Rogers
_______________________
runCommnd.c Explanation:
We use execvp to execute the command b/c it handles the environment path correctly. We print the statistics pertaining to the command using getrusage and gettimeofday after the execution.
Our runCommand handles illegal commands, and other exceptions.

Testing: We tested this program by thinking of all the exception cases and then giving it each individual command and pasting the output to the test file. (tjere's only one file for the test)
____________________
shell.c Explanation:
Works for both an interactive input mode or a piped file input mode. We handle the exit and cd dir commands as explained in the project overview.
In case of bad arguments it return an aproprite error message and prompts user for next command (if in interactive) else, it will still print the error in the non-interactive mode and will continue execution of file. We use the strtok function to parse commands into tokens, broken by spaces and new lines (b/c getline inputs newline char into the final string.) We will not accept 128 characters or 32 arguments, and will just cut off the command at 128 char/32 arg and give the user an apropriate warning. We ensure that the statistics are only for single commands and are not cumulative.

Testing: We tested each of the particulars set up in the assignment (cd and exit) as well as incorrect commands, and correct commands together. We stress tested with the 32+ commands and the ove 128 char command. All worked fine and is in a septerate output file.
____________________
shell2.c Explanation
We support background commands!
Our data structure for doing this is a linked list (which is doubly linked furst node to seccond node and seccond node to first). We have a node structure containing pertinent information to each job, and link them together with one of the parameters in the structure. Every time we create a node, we put it at the end of the list and update the start and end pointers of the list. Every time we delete a node, we update the start and end pointers apropriatley, and re-link the previous and next nodes to eachother. If the nodes are null, we deal with it apropriatley. We also have a function for iterating over the list and printing all of its members (active jobs) which is called in the non-interactive and the interactive functions. We user waitpid with the WNOHANG option turned on to ensure no proceses are blocked while a child is running. We have a loop that keeps checking for returned child processes to print and then delete. Our outstanding processes are handled with our linked list and will force the program to chill till they're done if exit is called.

Testing: we tested everything we had in shell.c + some background commands that were both correct and incorrect. We put a make in the beginning to make sure that the commands could run in the background and foreground out of order. They did.The stats printed correctly and all our output from this test is in anohter file. We checked to make sure our list functions were wworking correctly by interspersing our commands with the jobs command.
