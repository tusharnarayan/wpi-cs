/* Program queuetest.c
 * Tests the functionality of a queue with pointers as queue elements.
 * @author Tushar Narayan
 */
 
#include <stdlib.h>
#include <stdio.h>
#include "queue.h"

typedef struct {
  int x;
  double y;
} Foo; // Just some arbitrary struc


/** Main function
 * Tests the functions for a queue system.
 * @return 0 indicating success
 */
int main() {
  printf("\nProgram to test the functionality of queue functions.");

  const int max_entries = 5; // size of queue
  Foo* new_foo1;
  Foo* new_foo2; 
  Foo* new_foo3; 
  Foo* new_foo4; 
  Foo* new_foo5;
  Foo* new_foo6;
  Foo* new_foo7;
  Foo* new_foo8;
 
  Foo* returned_foo;

  // First, create a queue
  Queue *new_queue = create_queue(max_entries);

  // Allocate a Foo and enqueue it into the queue.
  new_foo1 = (Foo *) malloc(sizeof(Foo));
  new_foo1->x = 6;
  new_foo1->y = 14.79;
  printf("\nEnqueuing: x = %5d, y = %10.3f\n", new_foo1->x, new_foo1->y);
  enqueue(new_queue, (void *) new_foo1);
 

  // Allocate another Foo and enqueue it into the queue.
  new_foo2 = (Foo *) malloc(sizeof(Foo));
  new_foo2->x = 217;
  new_foo2->y = 3.14159;
  printf("Enqueuing: x = %5d, y = %10.3f\n", new_foo2->x, new_foo2->y);
  enqueue(new_queue, (void *) new_foo2);

  //Allocating some more Foos and enqueuing them into the queue.
  new_foo3 = (Foo *) malloc(sizeof(Foo));
  new_foo3->x = 4566;
  new_foo3->y = 2.722222;
  printf("Enqueuing: x = %5d, y = %10.3f\n", new_foo3->x, new_foo3->y);
  enqueue(new_queue, (void *) new_foo3);

  new_foo4 = (Foo *) malloc(sizeof(Foo));
  new_foo4->x = 753;
  new_foo4->y = 1.345;
  printf("Enqueuing: x = %5d, y = %10.3f\n", new_foo4->x, new_foo4->y);
  enqueue(new_queue, (void *) new_foo4);

  // See the front of the Queue
  returned_foo = (Foo *) at_queue_top(new_queue);
  printf("\nPeeked:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Enqueue some more Foos
  new_foo5 = (Foo *) malloc(sizeof(Foo));
  new_foo5->x = 299;
  new_foo5->y = 10.314159;
  printf("Enqueuing: x = %5d, y = %10.3f\n", new_foo5->x, new_foo5->y);
  enqueue(new_queue, (void *) new_foo5);

  // See the front of the Queue
  returned_foo = (Foo *) at_queue_top(new_queue);
  printf("\nPeeked:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Retrieve the Foos and print them.
  returned_foo = (Foo *) dequeue(new_queue);
  printf("\nDequeued:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  
  // See the front of the Queue
  returned_foo = (Foo *) at_queue_top(new_queue);
  printf("\nPeeked:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Dequeue another Foo
  returned_foo = (Foo *) dequeue(new_queue);
  printf("Dequeued:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Enqueue another
  new_foo7 = (Foo *) malloc(sizeof(Foo));
  new_foo7->x = 546;
  new_foo7->y = 125.09;
  printf("\nEnqueuing: x = %5d, y = %10.3f\n", new_foo7->x, new_foo7->y);
  enqueue(new_queue, (void *) new_foo7);

  // See the front of the Queue
  returned_foo = (Foo *) at_queue_top(new_queue);
  printf("\nPeeked:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Enqueue another
  new_foo8 = (Foo *) malloc(sizeof(Foo));
  new_foo8->x = 101;
  new_foo8->y = 566.2;
  printf("\nEnqueuing: x = %5d, y = %10.3f\n", new_foo8->x, new_foo8->y);
  enqueue(new_queue, (void *) new_foo8);

  // See the front of the Queue
  returned_foo = (Foo *) at_queue_top(new_queue);
  printf("\nPeeked:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Try to enqueue more elements than the declared queue can handle
  new_foo6 = (Foo *) malloc(sizeof(Foo));
  new_foo6->x = 3156;
  new_foo6->y = 22.15159;
  printf("\nTrying to enqueue more elements than queue can have...\n");
  printf("Enqueuing: x = %5d, y = %10.3f\n", new_foo6->x, new_foo6->y);
  int test = enqueue(new_queue, (void *) new_foo6);
  if(test == -1){ // enqueue returns -1 in case of overflow
    printf("\nTried to enqueue more elements than queue can handle!\n");
    printf("\nLast enqueue operation aborted.\n");
  }

  // Retrieve all the Foos and print them.
  returned_foo = (Foo *) dequeue(new_queue);
  printf("\nDequeued:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  returned_foo = (Foo *) dequeue(new_queue);
  printf("Dequeued:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  returned_foo = (Foo *) dequeue(new_queue);
  printf("Dequeued:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  returned_foo = (Foo *) dequeue(new_queue);
  printf("Dequeued:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
   
  // Check for underflow after dequeue try
  returned_foo = (Foo *) dequeue(new_queue);
  if(returned_foo == NULL)
    printf("\nYou have problems.\n");
  else
    printf("Dequeued:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);
  // Check for underflow after dequeue try
  returned_foo = (Foo *) dequeue(new_queue);
  if(returned_foo == NULL)
    printf("\nTried to dequeue elements from empty queue, aborted!\n");
  else
    printf("Dequeued:  x = %5d, y = %10.3f\n", returned_foo->x, returned_foo->y);

  // Clean up
  printf("\nCleaning up the queue...\n");
  delete_queue(new_queue);
 
  printf("\nDone! Exiting...\n");

  return 0; // indicating success!
}
