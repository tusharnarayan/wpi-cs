/* File queue.c
 * Contains functions for creating queues.
 * Also has functions for enqueuing, dequeuing, and peeking 
 * at the front of queues.
 * @author Tushar Narayan
 */

#include <stdlib.h>
#include <stdio.h>
#include "queue.h"

Queue *create_queue(int max_cells) {
  Queue *new_queue; // Holds pointer to the newly-allocated Queue structure.
  new_queue = (Queue *) malloc(sizeof(Queue)); 

  if (new_queue == NULL) return NULL; // Error--unable to allocate.

  // Fill in the queue
  new_queue->max_cells = max_cells;
  new_queue->cells_used = 0; // Empty to start

  // Now allocate space for the queue entries.
  new_queue->queue_head = (void **) calloc(sizeof(void *), max_cells);
  if (new_queue->queue_head == NULL) {
    free(new_queue); // Unable to allocate queue entries, so free struct.
    return NULL;
  }
  
  // the head is the base in memory, the tail is the top.
  // difference between base and top is array size, i.e. max_cells
  new_queue->queue_tail = new_queue->queue_head + max_cells ;

  new_queue->next_head = new_queue->queue_head; // Start head at front of queue
  new_queue->next_tail = new_queue->queue_head; // Start base at front of queue

  return new_queue;
}

void delete_queue(Queue *which_queue) {
  free(which_queue); // Free the struct
  /* Freeing the queue_head pointer would lead to a segfault
     since the dequeue function can also wrap around the queue.
     Also, the instructions didn't mention making a delete
     queue function anway.
  */
}

int enqueue(Queue *which_queue, void *ptr) {
  // Check if queue is already full 
  if ((which_queue->cells_used) >= (which_queue->max_cells)) {
    which_queue->cells_used = which_queue->max_cells; // Fix
    return -1;  // Queue overflow.
  }

  // Enqueue in queue.Remember, this is done at end of queue.
  *(which_queue->next_tail) = ptr;  // Store the pointer in the queue
  (which_queue->next_tail)++;       // Point to next free spot in queue

  (which_queue->cells_used)++; 
  return 0;  // Success
}

void* dequeue(Queue *which_queue) {
  // Check if queue is empty
  if ((which_queue->cells_used) <= 0) {
    which_queue->cells_used = 0; // Fix
    return NULL;  // Queue empty
  }

  void** top = which_queue->next_head;

  // Dequeue from queue. Remember, this is done from beginning of queue
  which_queue->next_head++;
 
  // Wrapping around if next_head is at the end of queue
  if(which_queue->next_head == which_queue->next_tail)
    which_queue->next_head = which_queue->queue_head;

  (which_queue->cells_used)--;

  return (*(top));
}

void* at_queue_top(Queue *which_queue) {
  // Check if queue is empty
  if ((which_queue->cells_used) <= 0) {
    which_queue->cells_used = 0; // Fix
    return NULL;  // Queue empty
  }

  // Return top of queue, without dequeuing.
  void** top = which_queue->next_head;

  return (*top); // Get the entry
}

