#include <stdio.h>
/*
 *Tushar Narayan
 *tnarayan@wpi.edu
 *
 *Test function - Intern Programming Survey
 */

/*
 * function countWordLength
 * Consumes a sentence stored in a string, and outputs a string 
 * containing the number of characters in each word (including punctuation) 
 * of the input string.
 * Example: If input is "This is a short sentence.", string outputted should 
 * be "4 2 1 5 9" (notice that the period is counted as part of the 
 * word 'sentence'.
 * @param inputString pointer to the string whose word lengths will be counted
 * @return void
 */
void countWordLength(char* inputString){
  int i, j, counter; // loop counters

  printf("\nSentence received:\n");
  for(i = 0; inputString[i] != '\0'; i++) printf("%c", inputString[i]);

  printf("\n\nIn order, word lengths are:\n");
  for(i = 0; inputString[i] != '\0'; i = j + 1){
    counter = 0;
    for(j = i; inputString[j] != ' ' && inputString[j] != '\0'; j++, counter++)
      if(counter>0) printf("%d ", counter);
  }
  printf("\n");
}

int main(void){
  printf("Welcome.\nI count word lengths in a sentence.\n");
  char *test1 = "This is a short sentence.";
  countWordLength(test1);
  return 0; // indicating success!
}
