/*
 * Mark Claypool
 * WPI
 * copyright 2003
 *
 * show use of environment 
 */

#include <stdio.h>
#include <stdlib.h>		/* for getenv() */

char *getenv(const char *name);

int main(int argc, char *argv[]) {
  extern char **environ;	/* externally declared */
  char *match;			

  if (argc != 2) {
    fprintf(stderr,"Usage: env {var}\n");
    exit(1);
  }

  match = getenv(argv[1]);
  if (!match)
    printf("No match for '%s' in environment\n", argv[1]);
  else
    printf("%s=%s\n", argv[1], match);
}

