#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>

#define MAXLINE 100
// MAXLINE is maximum length of an input line.


int main() {
  char *inputline; // pointer to input line
  int value; 
  int nc; // Number of conversions successfully completed
  int goodinput = 0; // Flag: 0 = false = Input not yet good  

  while (!goodinput) {
    inputline = readline("Enter a number: "); // Read the input line
    printf("You just entered this text {%s}\n", inputline); // Echo it
    nc = sscanf(inputline, "%d", &value); // Try to convert
    if (nc > 0) {
      printf("Valid number: %d\n", value);
      goodinput = 1; // Break out if successful
    } else {
      printf("Try again\n");
    }
  }

  return 0;
}

