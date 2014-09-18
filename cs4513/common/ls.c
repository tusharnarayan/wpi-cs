/*
 * ls.c
 *  
 * Mark Claypool, WPI
 * Fall 2011
 * 
 * Show basic directory operations.
 * Do "man readdir* for more information.
 */

#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <dirent.h>

/* (shown here for reference)
struct  dirent {
        ino_t    d_ino;               * inode number of entry *
        ushort_t d_reclen;            * length of this record *
        ushort_t d_namlen;            * length of string in d_name *
        char    d_name[256];	      * the actual directory names *
};
*/

main() {
  DIR *dp;
  struct dirent *d;

  dp = opendir(".");
  if (dp == NULL) {
    perror("open");
    exit(1);
  }

  d = readdir(dp);
  while (d) {
    printf("%s\n", d->d_name);
    d = readdir(dp);
  }

  closedir(dp);
  
}
