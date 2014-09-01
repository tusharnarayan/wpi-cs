/** 
 * File containing functions that 
 * operate on Employees.
 * @author Tushar Narayan
 * tnarayan@wpi.edu
 */
 
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include "mystructs.h"
#include <stdlib.h> //for malloc function
#include <readline/readline.h>
#include <readline/history.h>

/** Function printEmployee
 * prints the members of an Employee struct as output
 * @param *employee pointer to the Employee struct
 * @return void
 */
void printEmployee(Employee *employee) {
  fprintf(stdout, "Employee. Name = %s, Department = %s, Salary = %d\n",
	  employee->name, employee->dept, employee->salary);
}

/** Function outputEmployee
 * outputs the members of an Employee struct to a file
 * @param *stream pointer to the file that function will write to
 * @param *employee pointer to the Employee struct that will be written
 * @return void
 */
void outputEmployee(FILE *stream, Employee *employee) {
  fprintf(stream, "Employee. Name = %s, Department = %s, Salary = %d\n",
	  employee->name, employee->dept, employee->salary);
}

/** Function debug_def_checker
 * Checks if compilation occurred with the DEBUG symbol defined.
 * @return void
 */
void debug_def_checker(){
#ifdef DEBUG
  fprintf(stdout, "\nCompilation occured with the symbol DEBUG defined!\n");
#else
  fprintf(stdout, "\nNo DEBUG defined!\n");
#endif
}

/** Function makeEmployee
 * accepts as parameters data needed for an Employee struct, 
 * dynamically allocates the struct, fills in the data,
 * and returns a pointer to the new struct.
 * @param salary salary of new Employee
 * @param name name of new Employee
 * @param dept department that new Employee works in
 * @return pointer to the new struct
 */
Employee* makeEmployee(int salary, char *name, char *dept){
  Employee* new_emp_p; // a pointer to the struct
  new_emp_p = (Employee*) malloc(sizeof(Employee));
  
  // If no memory was available, return immediately
  if (new_emp_p == 0) return (Employee *) 0;
  
  new_emp_p -> salary = salary;
  new_emp_p -> name = strdup(name); //make a dynamic copy
  new_emp_p -> dept = strdup(dept); //make a dynamic copy
  
  return new_emp_p; //return pointer to dynamically allocated struct
}

/** Function inputEmployee
 * prompts the user to enter employee's name, salary, and department;
 * then allocates an Employee struct and puts the data into it
 * using the function makeEmployee.
 * Asks the user for each piece of data on a separate line with a
 * separate prompt. If the user enters an invalid salary, prompts the
 * user to try again.
 * @return pointer to the new struct
 */
Employee* inputEmployee(){
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
    /*printf("You just entered this text {%s}\n", inputline); // Echo it
      commented out as not required for program run*/
    nc = sscanf(inputline, "%d", &input_salary); // Try to convert
    if (nc > 0) {
      if(input_salary >= 0){
	printf("Valid salary: %d\n\n", input_salary);
	goodinput = 1; // Break out if successful
      } 
      else{
	printf("Try again. Salaries must be positive.\n");
      }
    }
    else {
      printf("Try again.\n");
    }
  }
  // loop to take in data for Employee name
  free(inputline); //freeing the dynamically allocated memory that readline allocates
  goodinput = 0; // reset flag before taking input
  nc = 0;
  while (!goodinput) {
    inputline = readline("Enter a name: "); // Read the input line
    /*printf("You just entered this text {%s}\n", inputline); // Echo it
      - commented out as not required for program run*/
    nc = sscanf(inputline, "%s", &input_name); // Try to convert
    if (nc > 0) {
      printf("Valid name: %s\n\n", input_name);
      input_name_p = input_name;
      goodinput = 1; // Break out if successful
    } else {
      printf("Try again\n");
    }
  }
  // loop to take in data for Employee department
  free(inputline); //freeing the dynamically allocated memory that readline allocates
  goodinput = 0; // reset flag before taking input
  nc = 0;
  while (!goodinput) {
    inputline = readline("Enter a department: "); // Read the input line
    /*printf("You just entered this text {%s}\n", inputline); // Echo it 
      - commented out as not required for program run*/
    nc = sscanf(inputline, "%s", &input_dept); // Try to convert
    if (nc > 0) {
      printf("Valid department: %s\n\n", input_dept);
      input_name_p = input_dept;
      goodinput = 1; // Break out if successful
    } else {
      printf("Try again\n");
    }
  }
  free(inputline); //freeing the dynamically allocated memory that readline allocates
  
  //Using inputs to dynamically allocate the employee
  new_emp_p = makeEmployee(input_salary, input_name, input_dept);
  return new_emp_p;
}
