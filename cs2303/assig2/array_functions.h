/** File array_functions.h
 * @author Tushar Narayan
 *
 * Header file for functions that operate on arrays
 */

#ifndef ARRAY_FUNCTIONS_H
#define ARRAY_FUNCTIONS_H

#define RANDOM_ARRAY_SIZE (10) /* setting size of the array 
				  containing random integers*/
#define RANDOM_MAX_NUM (500) /*setting upper limit for random 
			       number generation*/

// function prototypes:

void print_int_array(int a[], int size);
void generate_random_array(int a[]);
int generate_random_num();

#endif
