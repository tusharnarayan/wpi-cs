/** mystring.h
 * @author Mike Ciaraldi
 * Edited by Tushar Narayan
 * Header file for my own versions of some of the C-style string functions
 */

#ifndef MYSTRING_H
#define MYSTRING_H

//function prototypes with full header comments:

/** Duplicates a C-style string.
    @param src Pointer to string to be copied
    @return Pointer to freshly-allocated string containing a duplicate of src
    or null if no memory is available
*/
char* mystrdup(const char* src);

/** Function mystrlen
 * Function that calculates the length of the input string,
 * not including the terminating character
 * @param src_str String whose length has to be determined
 * @return length of the input string
 */
int mystrlen(const char* src_str);

/** Function mystrcpy
 * Function that copies the source string to the destination string
 * including the terminating character
 * @param dest_str String to where the source string has to be copied
 * @param src_str String that has to be copied
 * @return pointer to destination string
 */
char *mystrcpy(char* dest_str, const char *src_str);

/** Function mystrcat
 * Function that appends the source string to the destination string.
 * Overwrites the terminating character of the destination string and
 * then adds a terminating '\0' character.
 * The strings may not overlap, and the destination string must have
 * enough space for the result.
 * @param dest_str String to where the source string has to be appended
 * @param src_str String that has to be appended
 * @return pointer to destination string
 */
char *mystrcat(char* dest_str, const char *src_str);

/** Function mystrncat
 * Function that appends the source string to the destination string.
 * Overwrites the terminating character of the destination string and
 * then adds a terminating '\0' character. It uses at most n characters
 * from the source string.
 * The strings may not overlap, and the destination string must have
 * enough space for the result. Since the resut is always terminated with
 * '\0', at most n + 1 characters are written.
 * @param dest_str String to where the source string has to be appended
 * @param src_str String that has to be appended
 * @param n maximum number of characters that will be copied from source
 * @return pointer to destination string
 */
char *mystrncat(char* dest_str, const char *src_str, size_t n);

/** Function mystrndup
 * Function that duplicates a string and returns a pointer to the
 * duplicate string. Copies at most n characters. If the source
 * is longer than n, only n characters are copied and a terminating
 * null byte is added.
 * @param src_str String that has to be duplicated
 * @param n maximum number of characters that will be duplicated from source
 * @return pointer to freshly-allocated duplicated string or NULL 
 * if insufficient memory was available.
 */
char* mystrndup(const char* src, size_t n);

#endif
