/** File at2.c
 * @author Tushar Narayan
 *
 * Program for storing and printing arrays.
 */

/**
 * tnarayan@wpi.edu
 */

#include <stdio.h>
#include "print_arrays.h"
#include "array_functions.h"

/** Takes in an array of numbers and then prints them.
 * Repition controlled by special input and/or an upper counter limit.
 * @return 0 Indicates successful program completion.
 */
/* function main begins program execution */
int main( void )
{
  const int MAX_GRADES = 10; //maximum size of the array
  const int MAX_VALID_VALUE = 100; //maximum valid value that user can enter
  int grades[MAX_GRADES]; /* array to store all valid entered grades */
  int array_size; //stores the number of valid inputs that array contains

  /* instructions */
  printf( "\nWelcome \n" );
  printf( "\nEnter numbers. I will print them ,then sort & print them!\n" );
  printf( "\nSignify an end to entries by inputting a negative number.\n" );
  printf( "The maximum number of entries I can take is %d.\n\n", MAX_GRADES );

  /* Call function to get and store input into the array.
     The function returns the number of valid inputs in the array,
     store this value in the variable array_size.*/
  array_size = get_array_input(grades, MAX_GRADES, MAX_VALID_VALUE);

  printf( "\nThe input you gave me is:\n" );
  // call function to print the array
  print_int_array(grades, array_size);
  
  // call function to sort the array
  bubble_sort(grades, array_size);
  
  printf( "\nSorted form of the input is:\n" );
  // call function to print the sorted array
  print_int_array(grades, array_size);
  
  return 0; /* indicate program ended successfully */
} //end of main
