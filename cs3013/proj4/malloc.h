/* Cynthia Rogers - cerogers
 * Tushar Narayan - tnarayan
 * Project 4
 * malloc.h : header file for malloc functions
 */

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>

/*malloc:
 *allocates 'size' bytes and returns a void pointer to the memory
 *that was allocated. The memory can contain garbage values.
 *Internally, can ask for extra memory on a kernel trap and store the
 *excess in a linked list to avoid trapping to kernel frequently.
 */
void *malloc(size_t size);

/*calloc:
 *allocates memory for an array of 'number' elements, each of which is
 *of 'size' bytes, and returns a void pointer to the memory that was
 *allocated. The memory is set to zero.
 *Internally, calloc just relies on malloc to give it the memory
 *that is big enough to fit (number * size) bytes; and then initializes
 *that memory to zero.
 */
void *calloc(size_t number, size_t size);

/*realloc:
 *changes the size of the memory block pointed to by 'p' to 'size'
 *bytes. Previous contents are retained to the minimum of the old and
 *new sizes; newly allocated memory is uninitialized. 
 */
void *realloc(void *p, size_t size);

/*free:
 *frees the memory pointed to by 'p', which must be a pointer to a
 *dynamic memory block (i.e., memory that was returned by a previous
 *call to one of malloc, calloc, or realloc. Otherwise, try to fail
 *silently.
 */
void free(void *p);
