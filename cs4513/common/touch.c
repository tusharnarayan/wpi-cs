/*
 * Mark Claypool
 * WPI
 * copyright 2003
 *
 * show a use of the utime() call
 */

#include <stdio.h>
#include <stdlib.h>		/* for aoit() */
#include <unistd.h>		/* for getopt() */
#include <utime.h>		/* for utime() */
#include <sys/types.h>

void usage(void);

int main(int argc, char *argv[]) {
  char *file=NULL;		/* file to touch */
  time_t actime=0, modtime=0;	/* access time, modify time */
  struct utimbuf puttime;	/* to set time */
  int errflag=0;
  int dotime=0;			/* if a time flag was given */
  char c;

  while ((c = getopt (argc, argv, "ha:m:f:")) != EOF) {
    switch (c) {
    case 'f':
      file = optarg;
      break;
    case 'a':
      dotime = 1;
      actime = atoi(optarg);
      break;
    case 'm':
      dotime = 1;
      modtime = atoi(optarg);
      break;
    case '?': /* returns ? if there is a getopt error */
    case 'h':
      errflag++;
    }
  }
  if (errflag || !file)
    usage();
  
  if (dotime) {

    puttime.actime = actime;
    puttime.modtime = modtime;
    if (utime(file, &puttime)) 
      perror("utime");

  } else {			

    if (utime(file, NULL))   /* set to current time */
      perror("utime");

  }
}

/* print a usage message and quit */
void usage(void) {
    fprintf (stderr, "touch - set time of file\n");
    fprintf (stderr, "usage: {-f<name>} [-a<time>] [-m<time>] [-h]\n");
    fprintf (stderr, "\t-f\tfile name to set time\n");
    fprintf (stderr, "\t-a\taccess time to set (seconds since midnight, 01/01/70)\n");
    fprintf (stderr, "\t-m\tmodification time to set (seconds since midnight, 01/01/70)\n");
    fprintf (stderr, "\t-h\tdisplay this help message\n");
    exit(1);
}

