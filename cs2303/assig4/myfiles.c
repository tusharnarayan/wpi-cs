/** 
 * Program for reading and then printing Employee arrays from files.
 * @author Tushar Narayan
 * tnarayan@wpi.edu
 */

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h> //for malloc function
#include "mystructs.h"
#include <readline/readline.h>
#include <readline/history.h>

#define MAX_EMPS (5) //max number of employees to read from ASCII input file

/** Function inputFileEmployee
 * reads one Employee from a text file
 * @param *stream pointer to the file that function will read from
 * @return pointer to the struct that was read
 */
Employee* inputFileEmployee(FILE *stream){
  Employee* new_emp_p; // a pointer to the struct that will be read
  
  //variables to hold data for new Employee
  int input_salary; // variable to hold Employee salary read
  char input_name[80]; // array to hold Employee name read
  char input_dept[80]; // array to hold Employee department read

  //variables for entry loops
  int nc; //Variable to hold number of conversions made
  int count = 0; //counter to keep track of number of strings read
  int i; // loop counter
  int badinput = 0; //flag; 1 if fscanf did not work correctly
  
  while(!feof(stream) && count != 12 && badinput == 0)
    {
      count++;
      if(count == 6) {// 6 will be the Employee name
	nc = fscanf (stream, "%s", &input_name);
	if(nc <= 0)
	  badinput = 1;
      } else if(count == 9) {// 9 will be the Employee department
	nc = fscanf (stream, "%s", &input_dept);
	if(nc <= 0)
	  badinput = 1;
      } else if(count == 12) {// 12 will be the Employee salary
	nc = fscanf (stream, "%d", &input_salary);
	if(nc <= 0)
	  badinput = 1;
      } else //ignore all other inputs
	nc = fscanf (stream, "%*s");
    } //end of while
  if(badinput == 1){
    printf("Conversion not made successfully.");
    printf("Input file not formatted correctly. Exiting!\n\n");
    return (Employee*) NULL;
  }

  //for checking the file size, we make a special employee with negative salary
  if(feof(stream))
    new_emp_p = makeEmployee(-1000, "Sample", "Sample");

  //Using inputs to dynamically allocate the employee
  new_emp_p = makeEmployee(input_salary, input_name, input_dept);

  return new_emp_p;
}

/** Function printArrayEmployee
 * prints the members of an Employee struct as output
 * @param *employee pointer to the Employee 
 * @param emp_num employee number in the array
 * @return void
 */
void printArrayEmployee(Employee *employee, int emp_num) {
  fprintf(stdout, 
	  "Employee Number %d:\t Name = %s, Department = %s, Salary = %d\n",
	  emp_num, employee->name, employee->dept, employee->salary);
}

/** main program
 * @return 0 indicating success, 1 indicating that formatting 
 * in the input file is not as expected, 2 indicating that input file
 * was too big
 */
int main() {
  FILE *infile = fopen("myarrays.txt", "r"); // Open file for reading
  if(infile == NULL){
    fprintf(stderr, "Whoops! myfiles had error number %d - %s\n", 
	    errno, strerror(errno));
    printf("myarrays.txt doesn't exist!\n\n");
    return 1;
  }

  /*declaring an array of pointers, each of which can point to an 
    Employee struct */
  Employee* employees = (Employee*) (malloc(MAX_EMPS * sizeof(Employee)));

  //instructions
  printf("\nWelcome. I will read and print upto %d employees from myarrays.txt.\n", 
	 MAX_EMPS);

  int i; // loop counter
  Employee* new_emp; //variable to store the employee that is read

  for(i = 0; i < MAX_EMPS; i++){
    new_emp = inputFileEmployee(infile);
    if(new_emp == NULL){
      printf("Rerun myarrays to get an input file with correct formatting!");
      return 1;
    }
    employees[i] = *new_emp;
  }
  printf("\nRead %d employees successfully. Printing...\n", MAX_EMPS);
  
  // Output the employees to stdout.
  printf("\nPrinting details of the employees now:\n");
  for(i = 0; i < MAX_EMPS; i++){
    printArrayEmployee(&employees[i], i + 1);
  }

  //check to see if the input file still has data in it
  Employee* dup_emp = inputFileEmployee(infile);
  if(dup_emp -> salary > 0){
    fprintf(stderr, 
	    "\nWhoops! myfiles had more than %d employees!\n", MAX_EMPS);
    printf("The extra employees were not read or printed!\n");
    return 2;
  }

  return 0;
}
