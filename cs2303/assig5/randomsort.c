/* Program randomsort.c
 * Generates pseudo random strings, adds them to tree, then sorts and 
 * prints them.
 */

#include <time.h>
#include <stdlib.h>
#include <stdio.h>
#include "tree.h"

const int name_length = 8; //constant length for a name

/** Function generate_random_string
 * Generates and returns a random string.
 * Takes no parameters.
 * @return pointer to the generated random string.
 */
char* generate_random_string(){
  char *random_name = malloc(name_length);

  // if memory not allocated, return immediately!
  if(random_name == NULL) return (char*) NULL;

  int i; //loop counter

  /* special assignment for first character so as to get 
     an uppercase letter */
  random_name[0] = rand() % 26 + 65;

  // for the rest of the characters, using a loop
  for(i = 1; i < name_length; i++){
    /* expression for getting a random number between
       97 and 122, which is then implicitly promoted to the 
       corresponding lowercase ASCII character*/
    random_name[i] = rand() % 26 + 97;
  }
  return random_name;
}

/** Main function
 * Generates random strings, stores them in a tree, then sorts them,
 * and prints them in descending order.
 * @return 0 indicating success
 */
int main(){
  printf("\nProgram to generate random strings, store in tree, sort & print");
  printf("\n\nGenerating random strings...\n");

  srand(time(0)); /*seeding the random number generator
		       such that it gets a new seed every
		       time the program is run */

  // Generating random strings and printing them
  char *st1 = generate_random_string();
  char *st2 = generate_random_string();
  char *st3 = generate_random_string();
  char *st4 = generate_random_string();
  char *st5 = generate_random_string();

  printf("\nRandom strings are: %s, %s, %s, %s, %s.", st1, st2, st3, st4, st5);

  // Adding these random strings to nodes
  printf("\n\nAdding to tree...");
  Tnode *root_node = add_tnode(NULL_NODE, st1);
  root_node = add_tnode(root_node, st2);
  root_node = add_tnode(root_node, st3);
  root_node = add_tnode(root_node, st4);
  root_node = add_tnode(root_node, st5);
  printf("\nAll nodes added.\n");

  // Now printing the strings in descending order
  printf("\nPrinting tree now...\n");
  print_descending(root_node);

  // Now freeing all the nodes that were allocated
  printf("\nFreeing all the nodes now...\n");
  free_nodes(root_node);

  printf("\nDone! Exiting...\n\n");

  return 0; // indicating success!
}
