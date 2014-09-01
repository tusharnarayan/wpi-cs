/** mystructs.h
 * @author Tushar Narayan
 * Header file for functions that operate on structs
 */

#ifndef MYSTRUCTS_H
#define MYSTRUCTS_H

/** A struct that holds basic information about Employees
 */
struct MyEmpStruct{
  char* name;
  int birth_year;
  int starting_year;
};

typedef struct MyEmpStruct Employee;

//function prototypes:

Employee* make_employee(char* name, int birth_year, int starting_year);
void print_employee(Employee* emp_p);
Employee* create_random_emp();
char* generate_random_string();
int generate_random_year();
Employee* random_array_allocater(int count); 
void pointers_array_printer(Employee* base_emp, int count);
Employee* array_duplicater(Employee* base_emp, int count);
void array_deallocater(Employee* base_emp, int count);
Employee* deep_copy(Employee* base_emp, int count);

#endif
