/** 
 * Program for Employees using structs, pointers, arrays, and heap.
 * @author Tushar Narayan
 * tnarayan@wpi.edu
 */

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include "mystructs.h"

/** 
 * main function
 * @return 0 indicating success, 1 indicating file not opened successfully
 */
int main() {
  printf("\nStarting program stest.\n\n"); 

  // Anybody recognize these names?
  Employee harry; // Declare a local variable (a struct).
  harry.salary = 5000;
  harry.name = strdup("Harry Palmer"); // Make a dynamic copy.
  harry.dept = strdup("MI6"); // Make a dynamic copy.
  
  Employee bluejay; // Declare a local variable (a struct).
  bluejay.salary = 10000;
  bluejay.name = strdup("Erik Grantby"); // Make a dynamic copy.
  bluejay.dept = strdup("KGB"); // Make a dynamic copy.

  //Creating employees dynamically using function makeEmployee
  Employee* jason = makeEmployee(10000, "Jason Bourne", "CIA");
  int temp_salary = 1000;
  char *temp_name = "Carlos the Jackal";
  char *temp_dept = "Novgorod";
  Employee* carlos = makeEmployee(temp_salary, temp_name, temp_dept);
  Employee* user_emp1 = inputEmployee();
  
  // Output the employees to stdout.
  printEmployee(&harry);
  printEmployee(&bluejay);
  printEmployee(jason);
  printEmployee(carlos);
  printEmployee(user_emp1);
  
  // Output the employees to a file.
  printf("\nAbout to write to file.\n");
  FILE *outfile = fopen("stest.txt", "w"); // Open or create file for writing
  if(outfile == NULL){
    fprintf(stderr, "Whoops! stest had error number %d - %s\n", 
	    errno, strerror(errno));
    return 1;
  }
  outputEmployee(outfile, &harry);
  outputEmployee(outfile, &bluejay);
  outputEmployee(outfile, jason);
  outputEmployee(outfile, carlos);
  outputEmployee(outfile, user_emp1);
  fclose(outfile); // Close the file

  printf("\nEnding program stest.\n"); 
  debug_def_checker();
  return 0;
}
