#include <stdio.h>
#include <string.h>
// string.h covers the C-style string functions.
#include "mystring.h"
#include "mystructs.h"
#include <time.h> //for random number generation!

/** ctest.c
 * Program to demonstrate character arrays and
 * dynamically-allocated memory.
 * @author Mike Ciaraldi
 * Edited by Tushar Narayan
 */

int main()
{
  const int MAX_CHARS = 20; // Maximum number of characters in array
  char a1[MAX_CHARS + 1]; // Character array--initially empty
  char a2[] = "Hello"; // Character array--unsized but initialized
  char a3[MAX_CHARS + 1]; // Character array--we will underfill it
  char a4[] = "Hello"; // Character array--unsized by initialized
  char a5[MAX_CHARS + 1]; // Character array--we will underfill it
  char* p1 = "Hello"; // Pointer to constant string
  char* p2;           /* Will be a pointer to dynamically-allocated string
			 for mystrdup function demonstration */
  char* p3;           /* Will be a pointer to dynamically-allocated string
			 for mystrndup function demonstration */
  int copy_limit;     // Maximum characters to copy.

  mystrcpy(a3, "Hello, also"); // Initialize uinderfilled character array
  mystrncpy(a5, a3, 2); /*demonstrating what happens when n is less
			  than the length of the source string for
			  the mystrncpy function*/

  /* Print the pointers.
     Note: this example prints
     the values of the pointers themselves, not the targets.
  */
  printf("Pointers: a1 = %p, a2 = %p, a3 = %p, a4 = %p, a5 = %p\n", 
	 a1, a2, a3, a4, a5);
  printf("          p1 = %p p2 = %p p3 = %p\n", p1, p2, p3);

  mystrcpy(a1, "Hi"); // Initialize character array

  printf("a1 = %s\n", a1);
  printf("a2 = %s\n", a2);
  printf("a3 = %s\n", a3);
  printf("a4 = %s\n", a4);
  printf("a5 = %s\n", a5);

  // Concatenate two character arrays, then print.
  mystrcat(a1, a2);
  printf("a1 = %s\n", a1);

  // Concatenate two character arrays safely, then print.
  copy_limit = MAX_CHARS - mystrlen(a1); // How much space is left?
  if (copy_limit > 0) mystrncat(a1, a2, copy_limit);
  printf("a1 = %s\n", a1);

  // Concatenate two character arrays safely, then print.
  copy_limit = MAX_CHARS - mystrlen(a1); // How much space is left?
  if (copy_limit > 0) mystrncat(a1, a3, copy_limit);
  printf("a1 = %s\n", a1);

  // Duplicate a string, using my function, then print
  printf("Before dup, pointer a2 = %p, contents = %s\n", a2, a2);
  p2 = mystrdup(a2);
  printf("Pointer p2 = %p, contents = %s\n", p2, p2);

  // Duplicate a string safely, using my function, then print
  printf("Before dup, pointer a4 = %p, contents = %s\n", a4, a4);
  copy_limit = MAX_CHARS - mystrlen(a4); // How much space is left?
  if (copy_limit > 0) p3 = mystrndup(a4, copy_limit);
  printf("Pointer p3 = %p, contents = %s\n", p3, p3);

  // Creating structs using the make_employee function
  //first, allocating character arrays for names of employees
  char ename1[] = "Joe";
  char ename2[] = "Bob";
  char ename3[] = "Katherine";
  char ename4[] = "Laura";
  char ename5[] = "Laureli";
  //next, creating pointers to these character arrays
  char* epn1 = ename1;
  char* epn2 = ename2;
  char* epn3 = ename3;
  char* epn4 = ename4;
  char* epn5 = ename5;
  //third, creating birth year variables for each employee
  int edob1 = 1965;
  int edob2 = 1957;
  int edob3 = 1982;
  int edob4 = 1993;
  int edob5 = 1990;
  //last, creating starting year variables for each employee
  int estart1 = 1990;
  int estart2 = 1980;
  int estart3 = 1996;
  int estart4 = 2000;
  int estart5 = 2010;

  /* making the employee struct using the make_employee function
     and storing the returned pointer to Employee struct in
     appropriate variable */
  Employee* ep1 = make_employee(epn1, edob1, estart1);
  Employee* ep2 = make_employee(epn2, edob2, estart2);
  Employee* ep3 = make_employee(epn3, edob3, estart3);
  Employee* ep4 = make_employee(epn4, edob4, estart4);
  Employee* ep5 = make_employee(epn5, edob5, estart5);

  //this entire process can also be done in the following manner:
  char* emp_name_ptr = "Josh";
  Employee* ep6 = make_employee(emp_name_ptr, 1967, 1980);

  // Printing structs using the print_employee function
  printf("\n\nPrinting employee structs now:\n");
  print_employee(ep1);
  print_employee(ep2);
  print_employee(ep3);
  print_employee(ep4);
  print_employee(ep5);
  print_employee(ep6);

  srand(time(0)); /*seeding the random number generator
		       such that it gets a new seed every
		       time the program is run */
			   
			   
  // Create a random employee
  Employee* random_emp1 = create_random_emp();
  Employee* random_emp2 = create_random_emp();
  Employee* random_emp3 = create_random_emp();

  // Print the random employee
  printf("\n\nPrinting the random employee structs now:\n");
  print_employee(random_emp1);
  print_employee(random_emp2);
  print_employee(random_emp3);

  //defining a constant number of pointers to structs
  const int count = 10;
  
  // Allocate an array of pointers to structs, and print
  Employee* base_emp = random_array_allocater(count);
  
  // Print the array of pointers
  printf("\n\nPrinting the array of pointers to Employees now:\n\n");
  pointers_array_printer(base_emp, count);
  
  // (Shallow) Duplicate the array of pointers and print
  Employee* duplicate_base = array_duplicater(base_emp, count);
  printf("\n\nPrinting the shallow duplicate array of pointers now:\n\n");
  pointers_array_printer(duplicate_base, count);
  
  // (Deep) Duplicate the array of pointers and print
  Employee* deep_duplicate = deep_copy(base_emp, count);
  printf("\n\nPrinting the deep duplicate array of pointers now:\n\n");
  pointers_array_printer(deep_duplicate, count);

  // Deallocating the memory
  printf("\n\nDeallocating the memory now:\n\n");
  array_deallocater(base_emp, count); //segfault will occur here

  return 0;
}
