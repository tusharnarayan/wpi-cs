/* Cynthia Rogers - cerogers
 * Tushar Narayan - tnarayan
 * Project 4
 * test_malloc.c : test-cases for malloc, calloc, realloc, and free
 */

#include "malloc.h"

int main(){
  int* test_free_fail;
  char *test1 = (char *) malloc(sizeof(char) * 100);
  char *test2 = (char *) malloc(sizeof(char) * 15);
  if(test1 == NULL) printf("First malloc failed.\n");
  else{
    printf("First malloc succeeded!\n");
  }
  if(test2 == NULL) printf("Second malloc failed.\n");
  else{
    printf("Second malloc succeeded! Test printing input:\t");
    test2 = "This is a test string.";
    printf("%s\n", test2);
  }
  int *ptr = (int *)malloc(sizeof(int));
  *ptr = 90;
  printf("\nThe value stored at the memory pointed to by a malloc-ed integer pointer is %d.\n", *ptr);
  char *test_big = (char *) malloc(sizeof(char) * 110);
  test_big = "This is a test string to stress test the malloc function. The malloc function should be allocating memory. It's pretty awesome, as functions go. This is another line. This is a sentence. All of this will be printed out to test the malloc function.";
  printf("\n%s\n", test_big);

  //total memory available (through trial & error) -> malloc(3744);
  //on Cindy's VM

  int i;
  printf("\nTesting if malloc consistently works: malloc-ing 20 parts of %d bytes each:\n", sizeof(long));
  //100 parts worked on Cindy's computer, but only 20 on the server
  long* iterator;
  for(i = 1; i <= 20; i++){
    iterator = (long *) malloc(sizeof(long));
    if(iterator != NULL)
      printf("%d)\tmalloc worked!\n", i);
    else
      printf("%d)\tmalloc failed.\n", i);
  }
  printf("Freeing the last of those 20 parts...\n");
  free(iterator);
  printf("Call to free completed.\n");  

  int* test_array;
  test_array = (int *) calloc(20, sizeof(int));
  printf("\nNow testing calloc: getting memory for an integer array of 20 elements; all elements should be initialized to 0. Elements are:\n");
  for(i = 0; i < 20; i++){
    printf("%d\t", test_array[i]);
  }
  printf("\n");

  char* test_str = (char *) malloc(15 * sizeof(char));
  test_str = "Realloc Test!";
  printf("\nNow to test realloc: first malloc, then realloc:\n");
  printf("After malloc, string is:\t%s\n", test_str);
  realloc(test_str, 50);
  printf("After realloc, string is:\t%s\n", test_str);
  printf("Freeing the string...\n");
  free(test_str);
  printf("String freed.\n");

  printf("\nTrying to free a static variable: free should fail silently...\n");
  free(test_free_fail);
  printf("Free call for static variable has returned.\n");
  printf("\nEnd of tests, exiting...\n");
  return 0;
}
