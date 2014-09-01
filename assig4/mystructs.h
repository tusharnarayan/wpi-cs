/** 
 * Header file for functions that 
 * operate on Employees.
 * @author Tushar Narayan
 * tnarayan@wpi.edu
 */
 
#ifndef MYSTRUCTS_H
#define MYSTRUCTS_H

// Define some structures
/** 
 * struct _Employee
 * Structure for Employees.
 * Member variables - salary, character string, department string.
 * Monthly salary is in UK pounds sterling.
 * The character and department strings' pointers are dynamically
 * allocated from the heap.
 */
struct _Employee {
  int salary; // Monthly salary in UK pounds sterling
  char *name; // Pointer to character string holding name of employee.
              // MUST be dynamically allocated from the heap.
  char *dept; // Pointer to character string holding department of employee.
              // MUST be dynamically allocated from the heap.
};

typedef struct _Employee Employee; // For convenience

// function prototypes
void printEmployee(Employee *employee);
void outputEmployee(FILE *stream, Employee *employee);
void debug_def_checker();
Employee* makeEmployee(int salary, char *name, char *dept);
Employee* inputEmployee();

#endif
