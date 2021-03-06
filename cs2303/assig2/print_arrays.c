/** file print_arrays.c
 * @author Mike Ciaraldi
 * Edited by Tushar Narayan
 *
 * Functions for printing arrays of
 * integers and doubles, and for
 * taking user input for array data.
 */

#include <stdio.h>

/** Print an array of ints, one per line.
    @param a Array to print
    @param num_elements Number of elements in the array
*/
void print_int_array(int a[], int num_elements) {
  int i; // Loop counter

  /* iterating over the array and 
     printing the elements */
  for (i = 0; i < num_elements; i++) {
    printf("%d\n", a[i]);
  }
}

/** Print an array of doubles, one per line.
    @param b Array to print
    @param num_elements Number of elements in the array
*/
void print_double_array(double b[], int num_elements) {
  int i; //Loop counter

  /* iterating over the array and
     printing the elements */
  for(i = 0; i < num_elements; i++){
    printf("%f\n", b[i]);
  }
}

/** Function get_array_input
 * Takes an array and fills the array using user input.
 * Uses an upper bound combined with special user input to 
 * signify end of entries.
 *
 * @param a Array to fill with user input
 * @param MAX_INPUTS Maximum number of integers that this array can store
 * @param MAX_VALID_VALUE Maximum integer value of a particular input; 
 * values above this will be rejected
 *
 * @return The value of counter, which indicates successful 
 * function completion, and  also tells the calling function how many 
 * valid inputs were recorded
 */
int get_array_input(int a[], int MAX_INPUTS, int MAX_VALID_VALUE){
  int counter; /* counts number of valid integers in array */
  int value; /* input value */
  
  /* initialization phase */
  counter = 0; /* initialize loop counter */
  
  printf( "Enter integer: " ); /* prompt for input */
  scanf( "%d", &value ); /* read integer value from user */
  
  /* processing phase */
  while ( counter < MAX_INPUTS && value >= 0) { 
    /* loop remaining times and stop when integer value < 0 */
    
    if ( value <= MAX_VALID_VALUE ) { /* check if the integer 
					 value is greater than 
					 MAX_VALID_VALUE*/
      a[counter] = value; /* store integer value in the array */
      counter = counter + 1; /* increment counter */ 
    } /* end if */
    
    else {
      /* error message */
      printf( "The integer can't be greater than %d \n", MAX_VALID_VALUE ); 
    } /* end else */
    
    if(counter < MAX_INPUTS){
      /* check condition again so that we don't take in the extra input in 
	 the case when the counter has reached 19 but the while loop has 
	 yet to terminate 
      */
      printf( "Enter integer: " ); /* prompt for input */
      scanf( "%d", &value ); /* read integer value from user */
    }
  } /* end while */

  return counter; /* so that the main function knows how
		     valid inputs were stored in the array*/
} /* end function get_input */
