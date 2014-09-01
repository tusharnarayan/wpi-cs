#define _GNU_SOURCE
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h> // for write function, and basename function
#include <fcntl.h> // for flags in open function
#include <sys/time.h> // for timestamp
#include <sys/stat.h>
#include <sys/types.h> // for opendir
#include <dirent.h> // for opendir
#include <string.h> // for strdup

// function prototype
int copyfile1(char* infilename, char* outfilename);
int copyfile2(char* infilename, char* outfilename);
int copyfile3(char* infilename, char* outfilename, int bsize);

/** cptest.cpp
 * A file copying program.
 * Derived partially from caesar.cpp by Horstmann and Budd from big C++
 */

/**
   Prints usage instructions.
   @param program_name the name of this program
*/
void usage(char* program_name)
{  
  printf("Usage: %s infile outfile function#\n", program_name);
  printf("In case of function# 3, Usage: %s infile outfile function# buffer_size\n", program_name);
}

/**
   Prints file opening error message
   @param filename the name of the file that could not be opened
*/
void open_file_error(char* filename)
{  
  printf("Error opening file %s\n", filename);
}

/**
   Prints appropriate message depending on if the main program was successful
   @param returnstatus return value of the main program
   @param option number of the function that was used to copy files
*/
void result_message(int returnstatus, int option){
  if(returnstatus == 0)
    printf("\nFiles copied successfully, using function# %d.\n", option);
  else
    printf("\nFiles not copied successfully, please try again.\n");
}

/**
   Returns the difference between the timestamps obtained just before 
   and just after the call to the copying function
   The second parameter has to be a time later than the other.
   @param start_time timestamp just before the copying function was called
   @param end_time timestamp just after the copying function returns
   @return timeval struct which represents the difference of input structs,
   or NULL struct in case of error
 */
struct timeval copyduration(struct timeval start_time, struct timeval end_time){
  struct timeval difference; //struct to hold the difference between timestamps

  //set difference timestamp to negative values since difference not calculated
  difference.tv_sec = -20;
  difference.tv_usec = -20;
  
  // check if both fields of both timeval structs are positive
  if(end_time.tv_sec >=0 && end_time.tv_usec >= 0
     &&
     start_time.tv_sec >= 0 && start_time.tv_usec >= 0)
    {
      // check if second parameter is time later than first
      if(end_time.tv_sec >= start_time.tv_sec // seconds can be greater or same
	 && //but microseconds MUST be larger for time to be a later one
	 end_time.tv_usec > start_time.tv_usec){
	difference.tv_sec = end_time.tv_sec - start_time.tv_sec;
	difference.tv_usec = end_time.tv_usec - start_time.tv_usec;
      }
      else
	printf("\nWhile calculating difference between timestamps, second parameter is a time smaller than the first! Please revise order of input parameters and rerun.\n");
    }
  else{
    printf("\nInput timestamps are not valid times! Please rerun.\n");
  }
  return difference;
}

/** Main program: copies a file.
    @param argc Number of command-line arguments (including program name).
    @param argv Array of pointers to character arays holding arguments.
    @return 0 if successful, 1 if fail in copying, 2 if fail in timestamps
*/

int main(int argc, char* argv[])
{  
  char* infilename; // Names of files.
  char* outfilename;

  int option; // Choice of copying function to run
  int buffer_size; // size of buffer to be used for copyfile3

  if (!(argc == 3 || argc == 4 || argc == 5)) {
    usage(argv[0]); // Must have at least 2 arguments, and at most 4.
    return 1;
  }

  infilename = argv[1];

  // Determine if the second argument is a directory or a file
  const char* outputplace = argv[2]; // hold the 2nd command line argument
  DIR *copydir = opendir(outputplace);
  if(copydir == NULL){
    /* It could be that directory exists and user doesn't have permission
       to access it. However, for the purposes of this program, we assume
       that getting a NULL pointer means that argument was a file and 
       not a directory.
     */
    outfilename = argv[2];
  }
  else{ // argument was a directory, directory name is now stored in copydir
    char *ipath = strdup(argv[1]);
    ipath = basename(ipath); // saves the file with the extension

    int flength = strlen(ipath); // length of filename with extension
    int dlength = strlen(argv[2]); // length of directory name

    // malloc enough memory for the full pathname
    char *opath = (char *)malloc((flength + dlength + 2) * sizeof(char));
    /* add 2 since 1 for "/" between directory name and fileame, and 
	 1 for the terminating character*/

    strncpy(opath, argv[2], dlength+1); // path to directory
    strcat(opath, "/"); // add "/"
    strcat(opath, ipath); // add filename

    outfilename = opath; // save full path to output file
    free(opath);
  }
  

  // Process the other command line arguments, if any

  if(argc >= 4){ // function# specified in arguments
    option = atoi(argv[3]); // try to get function number

    if(option < 1 || option >3){ // wrong function number entered
      printf("Funtion# can only be either 1, 2, or 3. Try again.\n");
      usage(argv[0]);
      return 1;
    }

    else{
      if(option == 3){ // check if buffer size argument given for function 3
	if(argc == 5){
	  buffer_size = atoi(argv[4]); // try to get buffer size
	  if(buffer_size <= 0){ // incorrect buffer size entered
	    printf("Buffer size must be a number greater than 0. Try again.\n");
	    usage(argv[0]);
	    return 1;
	  }
	}
	else{
	  buffer_size = 1024; // default buffer size
	  printf("Since no buffer size specified, default of %d was used.\n", 
		 buffer_size);
	}
      }

      else {
	if(argc == 5){
	  printf("Since function 3 is not being used, buffer_size argument will be ignored!\n");
	printf("Just for reference, in case of function# 3:\n\tUsage: %s infile outfile function# buffer_size\n", argv[0]);
	}
      }
    }
  }
  else{
    option = 1; // default copying function is copyfile1
    printf("Since no function# specified, default (copyfile1) was used.\n");
  }

  
  int returnstatus;

  struct timeval start_time; /* variable to store timestamp before call to copy
				function */
  struct timeval end_time; /* variable to store timestamp after call to copy
			      function */

  gettimeofday(&start_time, NULL); // get timestamp just before copying

  // Perform the copying, using appropriate copying function
  if(option == 1)
    returnstatus = copyfile1(infilename, outfilename);
  else if(option == 2)
    returnstatus = copyfile2(infilename, outfilename);
  else
    returnstatus = copyfile3(infilename, outfilename, buffer_size);

  gettimeofday(&end_time, NULL); // get timestamp just after copying

  // Print appropriate message
  result_message(returnstatus, option);

  // Print the timestamps
  printf("\nRight before copying started, time was:\n");
  printf("%ld seconds, %ld microseconds\n", 
	 start_time.tv_sec, start_time.tv_usec);

  printf("\nRight after copying ended, time was:\n");
  printf("%ld seconds, %ld microseconds\n", 
	 end_time.tv_sec, end_time.tv_usec);

  // calculate how long the copying took
  struct timeval difference = copyduration(start_time, end_time);

  // check if copyduration function was successful
  if(difference.tv_sec == -20 || difference.tv_usec == -20)
    return 2;

  // Print how long the copying took
  printf("\nThe copying took:\n");
  printf("%ld seconds, %ld microseconds\n", 
	 difference.tv_sec, difference.tv_usec);

  return returnstatus;
}

/** Copies one file to another using formatted I/O, one character at a time.
    @param infilename Name of input file
    @param outfilename Name of output file
    @return 0 if successful, 1 if error.
*/
int copyfile1(char* infilename, char* outfilename) {
  FILE* infile; //File handles for source and destination.
  FILE* outfile;

  infile = fopen(infilename, "r"); // Open the input and output files.
  if (infile == NULL) {
    open_file_error(infilename);
    return 1;
  }

  outfile = fopen(outfilename, "w");
  if (outfile == NULL) {
    open_file_error(outfilename);
    return 1;
  }

  int intch;  // Character read from input file. must be an int to catch EOF.
  unsigned char ch; // Character stripped down to a byte.

  // Read each character from the file, checking for EOF.
  while ((intch = fgetc(infile)) != EOF) {
    ch = (unsigned char) intch; // Convert to one-byte char.
    fputc(ch, outfile); // Write out.
  }

  // All done--close the files and return success code.
  fclose(infile);
  fclose(outfile);

  return 0; // Success!
}

/** Copies one file to another using unformatted I/O, one character at a time.
    @param infilename Name of input file
    @param outfilename Name of output file
    @return 0 if successful, 1 if error.
*/
int copyfile2(char* infilename, char* outfilename) {
  int ifdesc; // file descriptor for infile
  int ofdesc; // file desciptor for outfile

  ifdesc = open(infilename, O_RDONLY);
  //return immediately if file not opened properly
  if(ifdesc < 0){
    open_file_error(infilename);
    return 1;
  }

  ofdesc = open(outfilename, O_WRONLY| O_CREAT| O_TRUNC, 0644);
  //return immediately if file not opened properly
  if(ofdesc < 0){
    open_file_error(outfilename);
    return 1;
  }

  int nw = 0; // number of bytes written, currently none
  int intch;  // Character read from input file. must be an int to catch EOF.
  char ch; // Character stripped down to a byte.

  // Read each character from the file, checking for EOF.
  while ((intch = read(ifdesc, &ch, sizeof(char))) != 0) {
    nw = write(ofdesc, &ch, sizeof(char)); // Write out
    if(nw <= 0) fprintf(stderr, 
			"\nWhoops! Error %d while writing: %s!\n",
			errno, strerror(errno));
  }

  // All done--close the files and return success code.
  close(ifdesc);
  close(ofdesc);

  return 0; // Success!
}

/** Copies one file to another using unformatted I/O, using buffer sizes.
    @param infilename Name of input file
    @param outfilename Name of output file
    @param bsize Size of the buffer
    @return 0 if successful, 1 if error.
*/
int copyfile3(char* infilename, char* outfilename, int bsize) {
  int ifdesc; // file descriptor for infile
  int ofdesc; // file desciptor for outfile

  void* ibuffer = malloc(bsize);

  ifdesc = open(infilename, O_RDONLY);
  //return immediately if file not opened properly
  if(ifdesc < 0){
    open_file_error(infilename);
    return 1;
  }

  ofdesc = open(outfilename, O_WRONLY| O_CREAT| O_TRUNC, 0644);
  //return immediately if file not opened properly
  if(ofdesc < 0){
    open_file_error(outfilename);
    return 1;
  }

  int nw = 0; // number of bytes written, currently none
  int intch;  // Character read from input file. must be an int to catch EOF.

  // Read each character from the file, checking for EOF.
  while ((intch = read(ifdesc, ibuffer, bsize)) > 0) {
    nw = write(ofdesc, ibuffer, intch); // Write out
    if(nw <= 0) fprintf(stderr, 
			"\nWhoops! Error %d while writing: %s!\n",
			errno, strerror(errno));
  }

  // All done--close the files and return success code.
  close(ifdesc);
  close(ofdesc);
  free(ibuffer);

  return 0; // Success!
}
