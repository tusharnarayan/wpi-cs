#include <stdlib.h>
#include "stack.h"

Stack *create_stack(int max_cells) {
  Stack *new_stack; // Holds pointer to the newly-allocated Stack structure.
  new_stack = (Stack *) malloc(sizeof(Stack)); 

  if (new_stack == NULL) return NULL; // Error--unable to allocate.

  // Fill in the struct
  new_stack->max_cells = max_cells;
  new_stack->cells_used = 0; // Empty to start

  // Now allocate space for the stack entries.
  new_stack->stack_base = (void **) calloc(sizeof(void *), max_cells);
  if (new_stack->stack_base == NULL) {
    free(new_stack); // Unable to allocate stack entries, so free struct.
    return NULL;
  }
  new_stack->next = new_stack->stack_base; // Start at base

  return new_stack;
}

void delete_stack(Stack *which_stack) {
  free(which_stack->stack_base); // Free memory block with stack entries.
  free(which_stack); // Then free the struct.
}

int push(Stack *which_stack, void *ptr) {
  // Check if stack is already full 
  if ((which_stack->cells_used) >= (which_stack->max_cells)) {
    which_stack->cells_used = which_stack->max_cells; // Fix
    return -1;  // Stack overflow.
  }

  // Push onto stack.
  *(which_stack->next) = ptr;  // Store the pointer on the stack
  (which_stack->next)++;       // Point to next free cell 
  (which_stack->cells_used)++; 
  return 0;  // Success
}

void* pop(Stack *which_stack) {
  // Check if stack is empty
  if ((which_stack->cells_used) <= 0) {
    which_stack->cells_used = 0; // Fix
    return NULL;  // Stack empty
  }

  // Pop from stack.
  (which_stack->next)--;         // Remember, this points to next free cell
  (which_stack->cells_used)--;
  return (*(which_stack->next));
}

void* peek(Stack *which_stack) {
  // Check if stack is empty
  if ((which_stack->cells_used) <= 0) {
    which_stack->cells_used = 0; // Fix
    return NULL;  // Stack empty
  }

  // Return top of stack, without popping.
  // Remember, 'next' points to next free cell
  void** top = (which_stack->next) - 1; // Point to real top of stack

  return (*top); // Get the entry
}
