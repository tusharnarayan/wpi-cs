/*
 * get-opt.c
 *  
 * Mark Claypool, WPI
 * Fall 2011
 * 
 * Show a use of the getopt()
 * 
 */


#include <stdio.h>
#include <stdlib.h>

void usage();

int main(int argc, char *argv[]) {
  int c;
  int bflag = 0, pflag = 0, errflag = 0;
  char *ofile = NULL, *ifile = NULL;
  extern int optind, opterr;
  extern char *optarg;

  opterr = 1; /* set to 0 to disable error message */

  /* required: one of {-b or -p}, optional: -i<name> and/or -o<name> */
  printf("processing argument: %d\n", optind);
  while ((c = getopt (argc, argv, "hbpi:o:")) != EOF) {
    switch (c) {
    case 'b':
      if (pflag)
	errflag++;
      else
	bflag++;
      break;
    case 'p':
      if (bflag)
	errflag++;
      else
	pflag++;
      break;
    case 'i':
      ifile = optarg;
      break;
    case 'o':
      ofile = optarg;
      break;
    case '?': /* returns ? if there is a getopt error */
    case 'h':
      errflag++;
    }
    printf("processing argument: %d\n", optind);
  }
  if (!bflag && !pflag)		/* need one of -b or -p */
    errflag++;
  if (errflag)
    usage();

  printf("infile: %s\n", ifile);
  printf("outfile: %s\n", ofile);
  if (bflag)
    printf("Go Broncos!\n");
  else 
    printf("Go Patriots!\n");
}

/* print a usage message and quit */
void usage(void) {
    fprintf (stderr, "getopt - test command line flags\n");
    fprintf (stderr, "usage: {-b|-p} [-i<name> -f<name>]\n");
    fprintf (stderr, "\t-b\t\tgo broncos!\n");
    fprintf (stderr, "\t-p\t\tgo patriots!\n");
    fprintf (stderr, "\t-i<file>\tinfile name\n");
    fprintf (stderr, "\t-o<file>\toutfile name\n");    
    fprintf (stderr, "\t-h\t\tdisplay this help message\n");
    exit(1);
}
