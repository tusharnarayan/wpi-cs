/* Fig. 3.6: fig03_06.c
   Class average program with counter-controlled repetition */

/** File assig1.c
 */

/**
 * Modified by Tushar Narayan
 * tnarayan@wpi.edu
 */

#include <stdio.h>
#include "calculatestats.h"

/** Computes the average of a class when given grades by user.
 * Repition controlled by special input and/or an upper counter limit.
 * @return 0 Indicates successful program completion.
 */

/* function main begins program execution */
int main( void )
{
  int counter; /* counts number of valid grades in array */
  int value; /* grade value */
  int grades[MAX_GRADES]; /* array to store all valid entered grades */
  
  /* initialization phase */
  counter = 0; /* initialize loop counter */
  
  /* instructions */
  printf( "\nWelcome \n" );
  printf( "\nEnter the grades and then I can tell you the average.\n" );
  printf( "\nSignify end of entries by inputting a negative number.\n" );
  printf( "The maximum number of entries I take is %d.\n\n", MAX_GRADES );
  
  printf( "Enter grade: " ); /* prompt for input */
  scanf( "%d", &value ); /* read grade value from user */
  
  /* processing phase */
  while ( counter < MAX_GRADES && value >= 0) { 
    /* loop remaining times and stop when grade value < 0 */
    
    if ( value <= 100 ) { /* measure that if the grade value greater than 100*/
      grades[counter] = value; /* store grade value in the array */
      counter = counter + 1; /* increment counter */ 
    } /* end if */
    
    else {
      printf( "The grade can't be greater than 100 \n" ); /* error message */
      counter = counter;
    } /* end else */
    
    if(counter < MAX_GRADES){
      /* check condition again so that we don't take in the extra input in 
	 the case when the counter has reached 19 but the while loop has 
	 yet to terminate 
      */
      printf( "Enter grade: " ); /* prompt for input */
      scanf( "%d", &value ); /* read grade value from user */
    }
  } /* end while */
  
  calculate_stats(grades, counter); /* call the function to 
				     calculate the average, the maximum and the minimum
				  */
  
  return 0; /* indicate program ended successfully */
} /* end function main */


/**************************************************************************
 * (C) Copyright 1992-2010 by Deitel & Associates, Inc. and               *
 * Pearson Education, Inc. All Rights Reserved.                           *
 *                                                                        *
 * DISCLAIMER: The authors and publisher of this book have used their     *
 * best efforts in preparing the book. These efforts include the          *
 * development, research, and testing of the theories and programs        *
 * to determine their effectiveness. The authors and publisher make       *
 * no warranty of any kind, expressed or implied, with regard to these    *
 * programs or to the documentation contained in these books. The authors *
 * and publisher shall not be liable in any event for incidental or       *
 * consequential damages in connection with, or arising out of, the       *
 * furnishing, performance, or use of these programs.                     *
 *************************************************************************/
