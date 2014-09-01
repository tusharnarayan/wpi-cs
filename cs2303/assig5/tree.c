/* File tree.c
 * Contains functions for adding nodes to binary trees.
 * Also has functions for printing the tree in descending order, and for
 * freeing all the nodes. 
 * @author Tushar Narayan
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "tree.h"

Tnode* add_tnode(Tnode *current_node, char* value){
  if(current_node == NULL){
    current_node = (Tnode *) malloc(sizeof(Tnode));

    if(current_node != NULL){
      current_node->value = value;
      current_node->left_child = NULL_NODE; //Assign to NULL
      current_node->right_child = NULL_NODE; //Assign to NULL
      return current_node;
    }
    else{ // malloc failed!
      printf("\nMemory could not be allocated!\n");
      return NULL_NODE; // return NULL_NODE if memory not allocated
    }
  }
  else {
    int cmp = strcmp(current_node->value, value); //compare the values
    if(cmp < 0)
      current_node->right_child = add_tnode(current_node->right_child, value);
    else if(cmp > 0)
      current_node->left_child = add_tnode(current_node->left_child, value);
    else{ // case for duplicate values of strings
      printf("\nDuplicate value, will be discarded!");
    }
  }
  return current_node;
}

void print_descending(Tnode* current_node){
  if(current_node != NULL){
    print_descending(current_node->right_child);
    printf("%s\n", current_node->value);
    print_descending(current_node->left_child);
  }
}

void free_nodes(Tnode* current_node){
  if(current_node != NULL){
    free_nodes(current_node->left_child);
    free_nodes(current_node->right_child);
    free(current_node);
  }
}
