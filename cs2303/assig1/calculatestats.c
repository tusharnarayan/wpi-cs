/** File calculatestats.c
 * @author Tushar Narayan
 * tnarayan@wpi.edu
 */

#include <stdio.h>
#include "calculatestats.h"

/** Function that accepts an array of grades and the number of elements
 * in the array. Computes the average, the minimum and the maximum; and
 * prints those values.
 * @param grades[MAX_GRADES] Array that stores the inputted grades
 * @param num_elements Represents the size of the array
 * @return void Only produces output.
 */

void calculate_stats(int grades[MAX_GRADES], int num_elements)
{
  /* variable declaration */
  int total; /* sum of grades input by user */
  int average; /* average of grades */
  int smallest; /* the smallest element of the array */
  int largest; /* the largest element of the array */
  
  /* variable initialization */
  total = 0;
  average = 0;
  
  /* processing (and output) phase */
  if ( num_elements != 0 ) { /* avoid dividing by 0 */
    
    /*
      Arbitrarily setting the default value of the minimum and maximum
      to the first value in the array
    */
    smallest = grades[0];
    largest = grades[0];
    
    /* calculation */
    
    /* iterating over the array elements using a for loop */
    int i; /* array indexer */
    for(i = 0; i < num_elements; i++) {
      total = total + grades[i]; /* adding up the total */
      
      /* if the value in smallest is larger than current array value,
	 replace the value of smallest */
      if ( smallest > grades[i] ) smallest = grades[i];
      
      /* if the value in largest is smaller than current array value,
	 replace the value of largest */
      if (largest < grades[i]) largest = grades[i];
    } /* end for */
    
    /* output phase */
    average = total / num_elements; /* division */
    printf( "\nClass average is %d\n", average ); /* display result */
    printf( "Smallest element is %d\n", smallest ); /* display minimum value */
    printf( "Largest element is %d\n", largest ); /*display maximum value */
  } /* end if */ 
  
  else { 
    /* output phase */
    printf( "\nNo grades entered \n" ); /* remind the error */
  } /* end else */
}
