/* Program treetest.c
 * Tests the functionality of a tree sorting algorithm, 
 * and other tree functions.
 * @author Tushar Narayan
 */
 
#include <stdlib.h>
#include <stdio.h>
#include "tree.h"

/** Main program
 * Tests the functionality of a tree sorting algorithm, 
 * and other tree functions.
 * @return 0 indicating success
 */
int main() {
  printf("\nProgram to test the functionality of a tree sorting algorithm.");
  printf("\nAlso tests other tree functions.\n");

  printf("\nAdding nodes to the tree...");

  char* s1 = "Harry";
  char* s2 = "Ron";
  char* s3 = "Ginny";
  char* s4 = "Hermione";
  char* s5 = "Neville";
  char* s6 = "Luna";
  char* s7 = "Parvati";
  char* s8 = "Rrron";

  Tnode* root_node; //pointer to the tree base

  // Add some nodes to the tree
  printf("\n\nAdding node %s", s1);
  root_node = add_tnode(NULL_NODE, s1);
  printf("\nAdding node %s", s2);
  root_node = add_tnode(root_node, s2);
  printf("\nAdding node %s", s3);
  root_node = add_tnode(root_node, s3);
  printf("\nAdding node %s", s4);
  root_node = add_tnode(root_node, s4);
  printf("\nAdding node %s", s5);
  root_node = add_tnode(root_node, s5);
  printf("\nAdding node %s", s6);
  root_node = add_tnode(root_node, s6);
  printf("\nAdding node %s", s7);
  root_node = add_tnode(root_node, s7);

  // Testing the case of a duplicate string
  printf("\n\nNow trying to add a duplicate string:");
  printf("\nAdding node %s", s4);
  root_node = add_tnode(root_node, s4);

  // Testing the case of a second duplicate string
  printf("\n\nTrying to add another duplicate string:");
  printf("\nAdding node %s", s5);
  root_node = add_tnode(root_node, s5);

  // Adding another node
  printf("\n\nAdding node %s", s8);
  root_node = add_tnode(root_node, s8);

  // Now printing nodes in descending order
  printf("\n\nPrinting nodes in descending order:\n");
  print_descending(root_node);

  // Now freeing the nodes that were allocated
  printf("\nFreeing nodes now...\n");
  free_nodes(root_node);

  printf("\nDone! Exiting...\n\n");

  return 0; // indicating success!
}
