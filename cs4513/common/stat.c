/*
 * stat.c
 *  
 * Mark Claypool, WPI
 * Fall 2002, 2011
 *
 * Show basic use of the stat() system call.
 * Do a "man 2 stat" for more details.
 *
 */

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>		/* for stat() */
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int ret;			/* return value */
  struct stat buf;		/* struct to hold file stats */

  if (argc!=2) {
    fprintf(stderr,"Usage: stat <filename>\n");
    exit(1);
  }

  ret = stat(argv[1], &buf);
  
  if (ret != 0) {
    perror("Failed:");
    exit(ret);
  }

  printf("stat of: %s\n", argv[1]);
  printf("\tdev: %d\n",  buf.st_dev);
  printf("\tinode: %d\n", buf.st_ino);
  printf("\tmode: %d\n", buf.st_mode);
  printf("\tnlink: %d\n", buf.st_nlink);
  printf("\tuid: %d\n", buf.st_uid);
  printf("\tgid: %d\n", buf.st_gid);
  printf("\trdev: %d\n", buf.st_rdev);
  printf("\tsize: %d\n", buf.st_size);
  printf("\tblocksize: %d\n", buf.st_blksize);
  printf("\tblocks: %d\n", buf.st_blocks);
  printf("\tctime: %d\n", buf.st_atime);
  printf("\tatime: %d\n", buf.st_mtime);
  printf("\tmtime: %d\n", buf.st_ctime);

  if (S_ISDIR(buf.st_mode))
    printf("\tIt is a directory\n");

  if (S_ISREG(buf.st_mode))
    printf("\tIt is a regular file\n");

  exit(0);

}
