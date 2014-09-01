/** file at.c
 * @author Mike Ciaraldi
 * Edited by Tushar Narayan
 *
 * Program to demonstrate arrays in C.
 */

#include "print_arrays.h"

#define SAMPLE_INT_ARRAY_SIZE (10)
#define SAMPLE_DOUBLE_ARRAY_SIZE (10)

/** Main program for demonstrating arrays. It fills them and prints them.
 * @return 0, Indicating success.
 */
int main() {
  int i; // Loop counter for integers
  double j; // Loop incrementer for doubles
  int a[SAMPLE_INT_ARRAY_SIZE]; // Sample integer array for demonstration
  double b[SAMPLE_DOUBLE_ARRAY_SIZE]; // Array of doubles

  // Fill the integer array with consecutive integers
  for (i = 0; i < SAMPLE_INT_ARRAY_SIZE; i++) a[i] = i;

  // Fill the doubles array with consecutive doubles
  for (i = 0, j = 0.0; i < SAMPLE_DOUBLE_ARRAY_SIZE; i++, j++){
    b[i] = j;
  }

  // Now print out array of integers
  print_int_array(a, SAMPLE_INT_ARRAY_SIZE);

  // Now print out array of doubles
  print_double_array(b, SAMPLE_DOUBLE_ARRAY_SIZE);

  return 0; // Success!
}
