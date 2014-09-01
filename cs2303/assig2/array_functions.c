/** File array_functions.c
 * @author Tushar Narayan
 *
 * Contains functions that operate on arrays.
 * Functions for sorting arrays using BubbleSort,
 * and filling in an array (using a random number
 * generator function).
 */

/**
 * tnarayan@wpi.edu
 */
 
#include "array_functions.h"
#include <time.h>
 
/** Function bubble_sort
 * Sorts an array of integers using the BubbleSort sorting algrithm.
 * @param a Array of integers to sort.
 * @param num_elements Number of elements in the array
 */
void bubble_sort(int a[], int num_elements) {
  int round; /*stores the level(number of rounds) 
	       of sorting*/
  int i; // loop counter
  int inorder; /* flag that stores 1 if all the array
		  elements are sorted, else 0*/
  int temp; // stores value of array data during swap

  inorder = 0; /* since the array is assumed to be unsorted
		  at input time*/

  /* Outer for loop controls the level of sorting
     that is still required*/
  for(round = num_elements - 1; round >= 1, inorder == 0; round--){
    /* Inner for loop controls the sorting of a particular
       element - the sinking down attribute of the algorithm*/
    for(i =0, inorder = 1; i < round; i++){
      /* check to see if current element is larger than the
	 next element in the array. If yes, swap them.
	 Else, continue to the next iteration. */
      if(a[i] > a[i + 1]){
	/*resetting flag to indicate that the array
	  is not sorted */
	inorder = 0;
	/* swapping the two elements 
	   using a temporary variable */
	temp = a[i];
	a[i] = a[i + 1];
	a[i + 1] = temp;
      }
    }
  }
}

/** Function generate_random_array
 * Fills an array with random integers.
 * @param a Array to fill with random integers.
 */
void generate_random_array(int a[]) {
  int i; // loop counter
  srand(time(NULL)); /*seeding the random number generator
		       such that it gets a new seed every
		       time the program is run */
  for(i = 0; i < RANDOM_ARRAY_SIZE; i++){
    /* call function to get random number,
       store that number in array */
    a[i] = generate_random_num();
  }
}

/** Function generate_random_num
 * Generates and returns a random integer.
 * @return The generated random integer.
 */
int generate_random_num() {
  /* expression for getting a random number
     between 0 and the RANDOM_MAX_NUM value,
     and storing this number in the 
     random_num variable */
  int random_num = rand() % (RANDOM_MAX_NUM + 1);
  return random_num;
}
