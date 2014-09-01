/** mystring.c
 * @author Mike Ciaraldi
 * My own versions of some of the C-style string functions
 * Edited by Tushar Narayan
 */

#include <string.h>
#include <stdlib.h>
// stdlib.h is needed to use malloc()
#include "mystring.h"

/** Function mystrdup
 * Function that duplicates a string and returns a pointer to the
 * duplicate string.
 * @param src String that has to be duplicated
 * @return pointer to freshly-allocated duplicate string or NULL 
 * if insufficient memory was available.
 */
char* mystrdup(const char* src){
  int length; // Length of the source string
  char* newstr; // Pointer to memory which will hold new string

  length = mystrlen(src) + 1;  // Leave space for the terminator
  newstr = (char*) malloc(length); // Must cast!

  // If no memory was available, return immediately
  if (newstr == 0) return (char *) 0;

  // Otherwise, copy the string and return pointer to new string
  mystrcpy(newstr, src);
  return newstr;
}

/** Function mystrlen
 * Function that calculates the length of the input string,
 * not including the terminating character
 * @param src_str String whose length has to be determined
 * @return length of the input string
 */
int mystrlen(const char* src_str){
  int length; //variable to store the length of the string
  const char* p; //pointer to iterate over the array
  for(p = src_str; *p != '\0'; p++){
    length++;
  }
  return length;
}

/** Function mystrcpy
 * Function that copies the source string to the destination string
 * including the terminating character
 * @param dest_str String to where the source string has to be copied
 * @param src_str String that has to be copied
 * @return pointer to destination string
 */
char *mystrcpy(char* dest_str, const char *src_str){
  const char* p; //pointer to iterate over the array for source string
  char* q; //pointer for array that stores destination string
  for(p = src_str, q = dest_str; *p != '\0'; p++, q++){
    *q = *p;
  }
  *q = '\0'; //adding the terminating character to the destination string
  q = dest_str; //resetting q so that it points to base of array again
  return q;
}

/** Function mystrcat
 * Function that appends the source string to the destination string.
 * Overwrites the terminating character of the destination string and
 * then adds a terminating  character.
 * The strings may not overlap, and the destination string must have
 * enough space for the result.
 * @param dest_str String to where the source string has to be appended
 * @param src_str String that has to be appended
 * @return pointer to destination string
 */
char *mystrcat(char* dest_str, const char *src_str){
  const char* p; //pointer to iterate over the array for source string
  char* q; //pointer for array that stores destination string
  for(q = dest_str; *q != '\0'; q++);
  for(p = src_str; *p != '\0'; p++, q++){
    *q = *p;
  }
  *q = '\0'; //adding the terminating character to the destination string
  q = dest_str; //resetting q so that it points to base of array again
  return q;
}

/** Function mystrncat
 * Function that appends the source string to the destination string.
 * Overwrites the terminating character of the destination string and
 * then adds a terminating character. It uses at most n characters
 * from the source string.
 * The strings may not overlap, and the destination string must have
 * enough space for the result. Since the resut is always terminated with
 * the terminating character, at most n + 1 characters are written.
 * @param dest_str String to where the source string has to be appended
 * @param src_str String that has to be appended
 * @param n maximum number of characters that will be copied from source
 * @return pointer to destination string
 */
char *mystrncat(char* dest_str, const char *src_str, size_t n){
  const char* p; //pointer to iterate over the array for source string
  char* q; //pointer for array that stores destination string
  size_t i = 0; //counter to keep track of number of characters copied
  for(q = dest_str; *q != '\0'; q++);
  for(p = src_str; *p != '\0', i < n; p++, q++, i++){
    *q = *p;
  }
  *q = '\0'; //adding the terminating character to the destination string
  q = dest_str; //resetting q so that it points to base of array again
  return q;
}

/** Function mystrncpy
 * Function that copies the source string to the destination string,
 * including the terminating characer. The destination string must be
 * large enough to receive the copy.
 * However, no more than n bytes of the src string are copied. Thus, if 
 * there is no null byte among the first n bytes of src, the result 
 * will not be null terminated.
 * @param dest_str String to where the source string has to be copied
 * @param src_str String that has to be copied
 * @param n maximum number of bytes that will be copied from source
 * @return pointer to destination string
 */
char *mystrncpy(char* dest_str, const char *src_str, size_t n){
  const char* p; //pointer to iterate over the array for source string
  char* q; //pointer for array that stores destination string
  size_t i = 0; //counter to keep track of number of characters copied
  for(p = src_str, q = dest_str; *p != '\0', i < n; p++, q++, i++){
    *q = *p;
  }
  if (i < n) // if there are still less than n bytes copied
    *q = '\0'; //we add the terminating character to the destination string
  q = dest_str; //resetting q so that it points to base of array again
  return q;
}

/** Function mystrndup
 * Function that duplicates a string and returns a pointer to the
 * duplicate string. Copies at most n characters. If the source
 * is longer than n, only n characters are copied and a terminating
 * null byte is added.
 * @param src String that has to be duplicated
 * @param n maximum number of characters that will be duplicated from source
 * @return pointer to freshly-allocated duplicated string or NULL 
 * if insufficient memory was available.
 */
char* mystrndup(const char* src, size_t n){
  int length; // Length of the source string
  char* newstr; // Pointer to memory which will hold new string

  length = n + 1;  // Leave space for the terminator
  newstr = (char*) malloc(length); // Must cast!

  // If no memory was available, return immediately
  if (newstr == 0) return (char *) 0;

  // Otherwise, copy the string and return pointer to new string
  mystrncpy(newstr, src, n);
  return newstr;
}
