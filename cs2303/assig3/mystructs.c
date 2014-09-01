/** mystructs.c
 * @author Tushar Narayan
 * Functions that operate on structs
 */

#include "mystructs.h"
#include <stdlib.h> //for malloc function
#include <stdio.h>
#include <time.h> //for random number generation!

#define name_length (6)

/** Function make_employee
 * Function that creates a variable of type Employee struct.
 * @param name pointer to string of employee
 * @param birth_year date of birth of employee
 * @param starting_year year the employee started work
 * @return pointer to newly_created struct or NULL if no memory available
 */
Employee* make_employee(char* name, int birth_year, int starting_year){
  Employee* new_emp_p; // a pointer to the struct
  new_emp_p = (Employee*) malloc(sizeof(Employee));
 
  // If no memory was available, return immediately
  if (new_emp_p == 0) return (Employee *) 0;

  new_emp_p -> name = name;
  new_emp_p -> birth_year = birth_year;
  new_emp_p -> starting_year = starting_year;
  return new_emp_p; // returning the pointer to the struct
}

/** Function print_employee
 * Function that prints the members of a variable of type Employee struct.
 * @param emp_p pointer to a struct of type Employee
 * @return void function only prints members
 */
void print_employee(Employee* emp_p){
  printf("Employee Name = %s\n", emp_p -> name);
  printf("Employee Birth Year = %d\n", emp_p -> birth_year);
  printf("Employee Starting Year = %d\n\n", emp_p -> starting_year);
}

/* Function create_random_emp
 * Function that creates a struct of type employee, fills it with random data
 * (that is, a random string and two random integers), and then returns the
 * newly created struct.
 * Takes no parameters.
 * @return pointer to the newly created struct or NULL if no memory available
 */
Employee* create_random_emp(){
  char* random_emp_name = generate_random_string();
  int random_birth_year = generate_random_year();
  int random_starting_year = generate_random_year();
  Employee* random_emp = make_employee(random_emp_name, random_birth_year,
				       random_starting_year);
  return random_emp;
}

/** Function generate_random_string
 * Generates and returns a random string.
 * Takes no parameters.
 * @return pointer to the generated random string.
 */
char* generate_random_string(){
  char *random_name = malloc(name_length);
  if(random_name == NULL) return (char*) NULL;
  int i; //loop counter

  /* special assignment for first character so as to get 
     an uppercase letter */
  random_name[0] = rand() % 26 + 65;

  // for the rest of the characters, using a loop
  for(i = 1; i < name_length; i++){
    /* expression for getting a random number between
       97 and 122, which is then implicitly promoted to the 
       corresponding lowercase ASCII character*/
    random_name[i] = rand() % 26 + 97;
  }
  return random_name;
}


/** Function generate_random_year
 * Generates and returns a random year.
 * Years can range from 1 to 2011
 * Takes no parameters.
 * @return the generated random year.
 */
int generate_random_year(){
  /* expression for getting a random number
     between 1 and 2000,
     and storing this number in the 
     random_num variable */
  int random_num = rand() % 2000 + 1;
  return random_num;
}

/** Function random_array_allocater
 * Takes a count and allocates an array which can hold that many pointers
 * to the struct, then fills each element of the array with a pointer to
 * a newly-created struct filled with random data.
 * @param count number of pointers to the struct that the function allocates
 * @return base of array of pointers
 */
Employee* random_array_allocater(int count){
  /*declaring an array of pointers, each of which can point to an 
    Employee struct */
  Employee* random_emps = (Employee*) (malloc(count * sizeof(Employee)));
  int i = 0; //loop counter
  
  for(i = 0; i < count; i++)
    random_emps[i] = *create_random_emp();

  return random_emps;
}

/** Function pointers_array_printer
 * Takes an array of pointers and a count, and
 * prints out all the structs that the pointers in the array point to.
 * @param base_emp the base of the array of pointers to be printed
 * @param count number of pointers to structs in the array
 * @return void
 */
void pointers_array_printer(Employee* base_emp, int count){
  int i; // loop counter
  for(i = 0; i < count; i++, base_emp++)
    print_employee(base_emp);
}

/** Function array_duplicater
 * Takes an array of pointers to structs, and duplicates just the pointers.
 * (shallow copy)
 * @param base_emp the base of the array of pointers to be printed
 * @param count number of pointers to the struct in array
 * @return the pointer to base of duplicate array
 */
Employee* array_duplicater(Employee* base_emp, int count){
  Employee* duplicate_emps = (Employee*) (malloc(count)); // duplicate array
  int i = 0; //loop counter
  for(i = 0; i < count; i++, base_emp++)
    duplicate_emps[i] = *base_emp;
	
  return duplicate_emps;
}

/** Function array_deallocater
 * Takes an array of pointers to structs, and deallocates it.
 * We have to assume that all the pointers have been returned by a 
 * previous call to malloc(). If not, segfaults occur, as shown below.
 *
 * WARNING - THIS FUNCTION WILL RETURN A SEGFAULT.
 *
 * @param base_emp the base of the array of pointers to be deallocated
 * @param count number of pointers to the struct in array
 * @return void
 */
void array_deallocater(Employee* base_emp, int count){
  int i = 0; //loop counter
  for(i = 0; i < count; i++, base_emp++)
    free(base_emp);
} //WARNING - THIS FUNCTION WILL RETURN A SEGFAULT.

/** Function deep_copy
 * Takes an array of pointers to structs, and duplicates it (deep copy).
 * @param base_emp the base of the array of pointers to be printed
 * @param count number of pointers to the struct in array
 * @return the pointer to base of duplicate array
 */
Employee* deep_copy(Employee* base_emp, int count){
  Employee* deep_duplicate = (Employee*) (malloc(count * sizeof(Employee))); 
  // duplicate array
  int i = 0; //loop counter
  for(i = 0; i < count; i++, base_emp++)
    deep_duplicate[i] = *(make_employee(base_emp->name, base_emp->birth_year, 
base_emp->starting_year));
	
  return deep_duplicate;
}
