/* Program stacktest.c
 * Tests the functionality of a stack with pointers as stack elements.
 * @author Tushar Narayan
 */
 
#include <stdlib.h>
#include <stdio.h>
#include "stack.h"

typedef struct {
  int x;
  double y;
} Foo; // Just some arbitrary struct

/** Main Function
 * Tests the functionality of the stack system.
 * @return 0 indicating success
 */
int main() {
  printf("\nProgram to test the functionality of stack functions.");

  const int max_entries = 5; // size of stack  
  Foo* new_foo1;
  Foo* new_foo2; 
  Foo* new_foo3; 
  Foo* new_foo4; 
  Foo* new_foo5;
  Foo* new_foo6;
  Foo* new_foo7;
  Foo* new_foo8;
 
  Foo* returned_foo;

  // First, create a stack
  Stack *new_stack = create_stack(max_entries);

  // Allocate a Foo and push it onto the stack.
  new_foo1 = (Foo *) malloc(sizeof(Foo));
  new_foo1->x = 6;
  new_foo1->y = 14.79;
  printf("\nPushing: x = %5d, y = %10.3f\n", new_foo1->x, new_foo1->y);
  push(new_stack, (void *) new_foo1);

  // Allocate another Foo and push it onto the stack.
  new_foo2 = (Foo *) malloc(sizeof(Foo));
  new_foo2->x = 217;
  new_foo2->y = 3.14159;
  printf("Pushing: x = %5d, y = %10.3f\n", new_foo2->x, new_foo2->y);
  push(new_stack, (void *) new_foo2);

  //Allocating some more Foos and pushing them onto the stack
  new_foo3 = (Foo *) malloc(sizeof(Foo));
  new_foo3->x = 4566;
  new_foo3->y = 2.722222;
  printf("Pushing: x = %5d, y = %10.3f\n", new_foo3->x, new_foo3->y);
  push(new_stack, (void *) new_foo3);

  new_foo4 = (Foo *) malloc(sizeof(Foo));
  new_foo4->x = 753;
  new_foo4->y = 1.345;
  printf("Pushing: x = %5d, y = %10.3f\n", new_foo4->x, new_foo4->y);
  push(new_stack, (void *) new_foo4);

  new_foo5 = (Foo *) malloc(sizeof(Foo));
  new_foo5->x = 299;
  new_foo5->y = 10.314159;
  printf("Pushing: x = %5d, y = %10.3f\n", new_foo5->x, new_foo5->y);
  push(new_stack, (void *) new_foo5);

  // Peek at the top of the stack
  returned_foo = (Foo *) peek(new_stack);
  printf("\nPeeked:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Retrieve the Foos and print them.
  returned_foo = (Foo *) pop(new_stack);
  printf("\nPopped:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  returned_foo = (Foo *) pop(new_stack);
  printf("Popped:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Push another Foo on stack
  new_foo7 = (Foo *) malloc(sizeof(Foo));
  new_foo7->x = 546;
  new_foo7->y = 125.09;
  printf("\nPushing: x = %5d, y = %10.3f\n", new_foo7->x, new_foo7->y);
  push(new_stack, (void *) new_foo7);

  // Peek at the top of the stack
  returned_foo = (Foo *) peek(new_stack);
  printf("\nPeeked:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Push another Foo
  new_foo8 = (Foo *) malloc(sizeof(Foo));
  new_foo8->x = 101;
  new_foo8->y = 566.2;
  printf("\nPushing: x = %5d, y = %10.3f\n", new_foo8->x, new_foo8->y);
  push(new_stack, (void *) new_foo8);

  // Peek at top
  returned_foo = (Foo *) peek(new_stack);
  printf("\nPeeked:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Push one more Foo. This is more than the declared stack can have.
  new_foo6 = (Foo *) malloc(sizeof(Foo));
  new_foo6->x = 3156;
  new_foo6->y = 22.15159;
  printf("\nTrying to push more elements than stack can have...\n");
  printf("Pushing: x = %5d, y = %10.3f\n", new_foo6->x, new_foo6->y);
  int test = push(new_stack, (void *) new_foo6);
  if(test == -1){ //the push function returns -1 in case of overflow
    printf("\nTried to push more elements than stack can handle!\n");
    printf("\nLast push operation aborted.\n");
  }

  // Retrieve all the Foos and print them.
  returned_foo = (Foo *) pop(new_stack);
  printf("\nPopped:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  returned_foo = (Foo *) pop(new_stack);
  printf("Popped:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  returned_foo = (Foo *) pop(new_stack);
  printf("Popped:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  returned_foo = (Foo *) pop(new_stack);
  printf("Popped:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  
  // Checking for underflow after retrieving Foo
  returned_foo = (Foo *) pop(new_stack);
  if(returned_foo == NULL)
    printf("\nYou have problems.\n");
  else
    printf("Popped:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  
  // Checking for underflow after retrieving Foo
  returned_foo = (Foo *) pop(new_stack);
  if(returned_foo == NULL)
    printf("\nTried to pop elements from empty stack, aborted!\n");
  else
    printf("Popped:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Clean up
  printf("\nCleaning up the stack...");
  delete_stack(new_stack);
  free(new_foo1);
  free(new_foo2);
  free(new_foo3);
  free(new_foo4);
  free(new_foo5);
  free(new_foo6);
  free(new_foo7);
  free(new_foo8);
  
  printf("\nDone! Exiting.\n");

  return 0; // indicating success!
}
