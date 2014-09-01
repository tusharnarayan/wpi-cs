Project 4
Cynthia Rogers - cerogers@wpi.edu
Tushar Narayan - tnarayan@wpi.edu
README file

Test Function:
We broke up our calling function, (our testing function) into different
functions stored in malloc.h. We tested if we could consistenly malloc, if we
could calloc an array of 20 elements. Then we tested realloc to se
if it would seg-fault, and it does not segfault. We also freed different
pointers to dynamic memory to test free.

Malloc:
There is one global variable that starts out as null which is our representation
of the original heap.If it's null, then the heap is empty, else, there is
memory allocated in the heap. Then once memory is allocated, the heap is
represented by our structure mem_chunk.  Malloc check the heap for free memory
that is of sufficient size. If no memory is found, then it requests memory
from the kernel using the sbrk system call. We made it so that sbrk is not
called everytime (causing a kernel trap). We did this by requesting extra
space on every call to sbrk & storing the extra space in the heap.

Calloc:
Calloc is similar to Malloc, but it has a different function signature (takes
different arguments). We use malloc to get the memory, and then loop through
it to initialize to 0.

Realloc:
Realloc either increases or decreases the malloc'ed pointer it is passed by
the size given. It also tries to decrease fragmentation by merging memory that
it has decreased with free memory around the new pointer.

Free:
Our free function frees allocated memory by setting the "free" flag of the
structure passed in our heap list to 0. It then also tries to merge that
memory with any free memory nodes around it effectivly, unlinking itself from
the list. Afterward, it ensures that the double links of the list are
maintained.
