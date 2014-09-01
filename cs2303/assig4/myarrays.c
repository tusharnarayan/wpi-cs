/** 
 * Program for Employees arrays.
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

/** Function inputArrayEmployee
 * prompts the user to enter employee's name, salary, and department;
 * then allocates an Employee struct and puts the data into it
 * using the function makeEmployee.
 * Asks the user for each piece of data on a separate line with a
 * separate prompt. If the user enters an invalid salary, prompts the
 * user to try again.
 * Slightly modified version of the inputEmployee function.
 * Optimized for taking in inputs for several employees
 * through less printing, and better formatting for array inputs.
 * @return pointer to the new struct
 */
Employee* inputArrayEmployee(){
  Employee* new_emp_p; // a pointer to the struct that will be created

  //variables to hold data for new Employee
  int input_salary; // variable to hold user-inputted Employee salary
  char input_name[80]; // array to hold user-inputted Employee name
  char *input_name_p; // pointer to hold user-inputted Employee name
  char input_dept[80]; // array to hold user-inputted Employee department
  char *input_dept_p; // pointer to hold user-inputted Employee department

  //variables for entry loops
  char *inputline; // pointer to input line
  int nc; // Number of conversions successfully completed
  int goodinput = 0; // Flag: 0 = false = Input not yet good  
  
  // loop to take in data for Employee salary
  while (!goodinput) {
    inputline = readline("Enter a salary: "); // Read the input line
    nc = sscanf(inputline, "%d", &input_salary); // Try to convert
    if (nc > 0) {
      if(input_salary >= 0){
	goodinput = 1; // Break out if successful
      } 
      else{
	printf("Try again. Salaries must be positive.\n");
      }
    }
    else {
      printf("Try again. Remember:  salaries must be a string of digits.\n");
    }
  }
  // loop to take in data for Employee name
  free(inputline); /*freeing the dynamically allocated memory 
		     that readline allocates*/
  goodinput = 0; // reset flag before taking input
  nc = 0;
  while (!goodinput) {
    inputline = readline("Enter a name: "); // Read the input line
    nc = sscanf(inputline, "%s", &input_name); // Try to convert
    if (nc > 0) {
      input_name_p = input_name;
      goodinput = 1; // Break out if successful
    } else {
      printf("Try again\n");
    }
  }
  // loop to take in data for Employee department
  free(inputline); /*freeing the dynamically allocated memory 
		     that readline allocates*/
  goodinput = 0; // reset flag before taking input
  nc = 0;
  while (!goodinput) {
    inputline = readline("Enter a department: "); // Read the input line
    nc = sscanf(inputline, "%s", &input_dept); // Try to convert
    if (nc > 0) {
      input_name_p = input_dept;
      goodinput = 1; // Break out if successful
    } else {
      printf("Try again\n");
    }
  }
  free(inputline); /*freeing the dynamically allocated memory 
		     that readline allocates*/
  
  //Using inputs to dynamically allocate the employee
  new_emp_p = makeEmployee(input_salary, input_name, input_dept);
  return new_emp_p;
}

/** Function printArrayEmployee
 * prints the members of an Employee struct as output
 * Slightly modified version of the printEmployee function.
 * @param *employee pointer to the Employee 
 * @param emp_num employee number in the array
 * @return void
 */
void printArrayEmployee(Employee *employee, int emp_num) {
  fprintf(stdout, 
	  "Employee Number %d:\t Name = %s, Department = %s, Salary = %d\n",
	  emp_num, employee->name, employee->dept, employee->salary);
}

/** Function outputArrayEmployee
 * outputs the members of an Employee struct to a file
 * puts each piece of data on a separate line
 * Slightly modified version of the outputEmployee function.
 * @param *stream pointer to the file that function will write to
 * @param *employee pointer to the Employee struct that will be written
 * @param emp_num employee number in the array
 * @return void
 */
void outputArrayEmployee(FILE *stream, Employee *employee, int emp_num) {
  fprintf(stream, 
	  "Employee Number: %d\n\tName = %s\n\tDepartment = %s\n\tSalary = %d\n\n",
	  emp_num, employee->name, employee->dept, employee->salary);
}

/** 
 * main function
 * @return 0 indicating success
 */
int main() {
  //variables for entry loop
  char *inputline; // pointer to input line
  int nc; // Number of conversions successfully completed
  int goodinput = 0; // Flag: 0 = false = Input not yet good  
  
  int num_emp; //variable to store number of employees
  
  //Instructions and prompt
  printf("\nWelcome. I will create arrays of Employees for you.\n");
  printf("\nHow many employees are there?\n");

  // loop to take in number of Employees
  while (!goodinput) {
    inputline = readline("Enter number of employees here: "); /* Read the 
								 input line*/
    nc = sscanf(inputline, "%d", &num_emp); // Try to convert
    if (nc > 0) {
      if(num_emp > 0){
	printf("%d is a valid number of employees.\n\n", num_emp);
	goodinput = 1; // Break out if successful
      } 
      else{
	printf("Try again. There must be at least 1 employee.\n");
      }
    }
    else {
      printf("Try again.\n");
    }
  }
  free(inputline); /* freeing the dynamically allocated memory 
		      that readline allocates */
 
  /*declaring an array of pointers, each of which can point to an 
    Employee struct */
  Employee* employees = (Employee*) (malloc(num_emp * sizeof(Employee)));
  printf("Now enter data for %d employees.\n", num_emp);
  int i = 0; //loop counter
  
  //loop to take entries
  for(i = 0; i < num_emp; i++){
    printf("\nEnter data for employee %d\n", i + 1);
    employees[i] = *inputArrayEmployee();
  }
	
  printf("\n");
	
  // Output the employees to stdout.
  printf("\nPrinting details of the employees now:\n");
  for(i = 0; i < num_emp; i++){
    printArrayEmployee(&employees[i], i + 1);
  }
  
  // Output the employees to a file.
  printf("\nAbout to write to file.\n");
  FILE *outfile = fopen("myarrays.txt", "w"); /* Open or create 
						 file for writing */
  if(outfile == NULL){
    fprintf(stderr, "Whoops! myarrays had error number %d - %s\n", 
	    errno, strerror(errno));
    return 1;
  }
  for(i = 0; i < num_emp; i++){
    outputArrayEmployee(outfile, &employees[i], i + 1);
  }
  fclose(outfile); // Close the file
  
  // free dynamically allocated array memory
  printf("\nData written to file myarrays.txt.\n");
  printf("\nFreeing dynamically allocated array memory now.\n");
  free(employees);
    
  printf("\nEnding program myarrays.\n"); 
  return 0;
}
