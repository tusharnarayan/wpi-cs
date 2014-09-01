/* Cynthia Rogers - cerogers
 * Tushar Narayan - tnarayan
 * Project 4
 * malloc.c : function definitions for malloc functions
 */

#include "malloc.h"

/* structure for storing meta-data on memory chunks */
struct mem_chunk{
  size_t size; //size of data of chunk
  struct mem_chunk *next; //pointer to next chunk
  struct mem_chunk *prev; //pointer to previous chunk
  int free; /*flag to indicate whether the particular chunk of 
	     *memory is not in use
	     */
  void *ptr; /*pointer to the allocated memory chunk.
	      *Used to check whether the pointer to free was a
	      *pointer that was allocated dynamically
	      */
  char data[1]; /*C forbids array of length 0. Need array to point to
		 *end of the meta-data
		 */
};
//Important Note: next and prev point to the chunk's structure

//simplifying use of type: will never use the type without a pointer
typedef struct mem_chunk *ptr_chunk; 

#define CHUNK_SIZE 20 //sizeof will be incorrect, manually define size

/*Need to align the pointers to the integer size.
 *Meta-data chunks are already aligned, but the size of the data chunk
 *must be aligned.
 *Let x be an integer such that x = 4*p + q with 0<=q<=3;
 *then if x is a multiple of four, q = 0 and x-1 = 4(p-1) + 3;
 *so ((x - 1)/4) * 4 + 4 = 4 * p = x.
 *If x is not a multiple of four, then q != 0 and x-1 = 4*p + (q - 1)
 *and 0 <= q - 1 <= 2;
 *so (x-1)/4 * 4 + 4 = 4 * p + 4 = x/4*4 + 4;
 *Thus, (x-1)/4*4 + 4 always results in the nearest greater or equal
 *multiple of 4.
 *Also, division == right bit-shift
 *And, multiplication == left bit-shift 
 */
#define aligner(x) (((((x) - 1) >> 2) << 2) + 4)

//base is a pointer to the start of the list
void *base = NULL; //NULL pointer implies an empty list

/*begin at base of heap, if current chunk is sufficient return, else 
 *continue till a fitting chunk is found.
 *If end of heap is encountered without finding a satisfactory chunk,
 *malloc will extend the heap - thus, store the last visited chunk and
 *return it.
 *argument last will always point to the last visited memory chunk
 *First Fit Algorithm used
 * Traverse the list of memory chunks and stop when a free chunk with
 * enough space to meet the request is found
 */
ptr_chunk find_suitable_chunk(ptr_chunk *last, size_t size){
  ptr_chunk p = base; //base is a global pointer to start of heap
  while((p != NULL) && !((p -> free) && (p -> size >= size))){
    *last = p;
    p = p -> next;
  }
  return p;
}

/*split_chunk: splits the memory chunk passed in as argument
 * to the size wanted.
 */
void split_chunk(ptr_chunk p, size_t size){
  // p MUST exist
  ptr_chunk new_chunk;
  //using p->data in pointer arithmetic to ensure that sum has byte precision
  new_chunk = (ptr_chunk) (p -> data + size);
  new_chunk -> size = p -> size - size - CHUNK_SIZE;
  new_chunk -> next = p -> next;
  new_chunk -> prev = p;
  new_chunk -> free = 1;
  new_chunk -> ptr = new_chunk -> data;
  p -> size = size;
  p -> next = new_chunk;
  if(new_chunk -> next != NULL)
    new_chunk -> next -> prev = new_chunk;
}

/*extend_heap:
 *add a new chunk at the end of the heap
 *else return NULL
 */
ptr_chunk extend_heap(ptr_chunk last, size_t size){
  ptr_chunk p;
  size_t total_size = 2.25 * size;
  int *sb;
  p = sbrk(0);
  sb = (int *) sbrk(CHUNK_SIZE + total_size);
  if(sb < (int *) 0) //sbrk failed
    return NULL;
  p -> size = size;
  p -> next = NULL;
  p -> prev = last;
  p -> ptr = p -> data;
  /*since extra space requested from kernel, need to ensure that 
   *only sufficient space is returned to user
   *extra space will be split off into another chunk and stored 
   *in list as free space
   */
  split_chunk(p, size);
  if(last != NULL) last -> next = p;
  p -> free = 0;
  return p;
}

/*malloc:
 *1) align the size requested
 *2) if base is initialized, try finding a free suitable chunk
 *   -if found, try splitting it, and mark it as used (the free flag)
 *   -else extend the heap
 *3) else extend the (empty) heap
 *if fail at any point, return NULL (as library malloc does too)
 */
void *malloc(size_t size){
  ptr_chunk p, last;
  size_t s;
  s = aligner(size);
  if(base != NULL){
    //try finding an empty chunk
    last = base;
    p = find_suitable_chunk(&last, s);
    if(p){
      //try splitting the chunk
      if((p -> size - s) >= (CHUNK_SIZE + 4)) split_chunk(p, s);
      p -> free = 0;
    }
    else{
      //no suitable empty chunk, extend heap
      p = extend_heap(last, s);
      if(p == NULL) return NULL;
    }
  }
  else{
    //this is the first time that memory is being requested
    p = extend_heap(NULL, s);
    if(p == NULL) return NULL;
    base = p;
  }
  return p -> data;
}

/*calloc:
 *1) malloc with the product of two operands
 *2) initialize any bytes to 0
 */
void *calloc(size_t number, size_t size){
  size_t *new;
  size_t s4, i;
  new = malloc(number * size);
  if(new != NULL){
    //iterate through the newly allocated memory; initialize to 0
    //data chunk's size in memory chunk has to be a multiple of 4
    //so iterate by 4 to be more efficient
    s4 = aligner(number * size) << 2;
    for (i = 0; i < s4; i++) new[i] = 0;
  }
  return new;
}

/*fuse_chunks
 *try to fuse memory_chunks that are next to each other and are empty
 *this is the reason the list is doubly-linked
 */
ptr_chunk fuse_chunks(ptr_chunk p){
  if((p -> next != NULL) && (p -> next -> free)){
    //next chunk is not NULL and is free
    p -> size += CHUNK_SIZE + p -> next -> size; /*sum sizes 
						  *(including the 
						  *meta-data struct!)
						  */
    p -> next = p -> next -> next; //ensuring links don't break
    if(p -> next) p -> next -> prev = p; /*if not end of list, 
					  *ensure double-link 
					  *still works
					  */
  }
  return p;
}

/*get_chunk
 *get the chunk of memory of the pointer that was passed to free
 */
ptr_chunk get_chunk(void *p){
  p -= CHUNK_SIZE;
  return p;
}

/*valid_addr
 *is the address a valid address to be freed?
 *first, is the pointer greater than the pointer to the 
 *base of the heap?
 *next, if p and ptr point to (same) data, then there is a high 
 *probability that the pointer address is really a chunk 
 *of memory that was malloc-ed
 */
int valid_addr(void *p){
  int return_value = 0;
  if(base){
    if(p > base && p < sbrk(0)){
      return_value = (p == (get_chunk(p)) -> ptr);
    }
  }
  return return_value;
}

/*free:
 *1) is the pointer valid?
 *   -get chunk address, mark as free
 *   -if previous chunk is free, try fusing them together to avoid fragmentation
 *   -also try fusion with the next chunk
 *   -if there are no more chunks in list, set base of list to NULL
 *2) if pointer is invalid, do nothing
 */
void free(void *p){
  ptr_chunk b;
  if(valid_addr(p)){
    b = get_chunk(p);
    b -> free = 1;
    if(b -> prev && b -> prev -> free) //fusion with previous chunk is possible
      b = fuse_chunks(b -> prev);
    //also try with next chunk
    if(b -> next) fuse_chunks(b);
    else{
      //are we at the end of the heap?
      if(b -> prev) b -> prev -> next = NULL;
      else base = NULL; //going back to original state
    }
  }
}

/*copy_chunk
 *a version of memcpy
 */
void copy_chunk(ptr_chunk src, ptr_chunk dest){
  int *src_data, *dest_data;
  size_t i; /* iterator/counter */
  src_data = src -> ptr;
  dest_data = dest -> ptr;
  /*again, we can iterate in blocks of 4 since data
   *and pointers are aligned
   */
  for(i = 0; ((i*4) < (src -> size)) && ((i*4) < (dest -> size)); i++)
    dest_data[i] = src_data[i];
}

/*realloc:
 *1) allocate new memory chunk using malloc
 *   -if size doesn't change, do nothing
 *   -if chunk is smaller, try splitting the chunk
 *   -if next chunk is free and has space, fuse and try splitting
 *2) copy data from old chunk to new chunk
 *3) free old chunk
 *4) return pointer to new chunk
 */
void *realloc(void *p, size_t size){
  //taking care of the special cases first
  if(p == NULL) return malloc(size);
  if(size == 0){
    free(p);
    return NULL;
  }
  size_t s;
  ptr_chunk b, new_chunk;
  void *new_p;
  if(valid_addr(p)){
    s = aligner(size);
    b = get_chunk(p);
    if(b -> size >= s){
      if((b -> size - s) >= (CHUNK_SIZE + 4))
	split_chunk(b, s);
    }
    else{
      //trying to fuse with next
      if((b -> next != NULL) && (b -> next -> free) && 
	 ((b -> size + CHUNK_SIZE + b->next->size) >= s)){
	fuse_chunks(b);
	if((b -> size - s) >= (CHUNK_SIZE + 4)) split_chunk(b, s);
      }
      else{
	/*none of the efficiency tricks relevant, 
	 *just realloc with a new chunk of memory
	 */
	new_p = malloc(s);
	if(new_p == NULL) return NULL; //no memory available
	new_chunk = get_chunk(new_p); //need to copy meta-data too!
	copy_chunk(b, new_chunk);
	free(p);
	return new_p;
      }
    }
    return p;
  }
  return NULL;
}
