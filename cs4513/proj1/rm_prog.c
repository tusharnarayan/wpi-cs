#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <libgen.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <utime.h>
#include <dirent.h>

//from http://web.cs.wpi.edu/~cs4513/d14/samples/env.c
char *getenv(const char *name);
//end code from samples/env.c

const int MAX_EXTENSION_VALUE = 20; /*max num extensions added to files in trash */

//from Tanenbaum's Modern Operating Systems textbook
#define FILE_COPY_BUF_SIZE 4096 /* use a buffer size of 4096 bytes */
#define FILE_COPY_OUTPUT_MODE 0700 /* protection bits for output file */
//end from Tanenbaum

/*Exit codes
 *1: ret_stat failed
 *2: directory without -r flag
 *3: no trash variable (neither in environment nor using -t flag)
 *4: exit from usage()
 *5: trash folder already has directory with similar name as the rm argument
 *6: file copy failed
 *7: trash is not a directory
 */

/* function prototypes */
void usage(void);
int process_filename(int predefined_trash_flag, char *match, int custom_trash_flag, char *custom_trash_path, char *entity_to_delete, int directory_flag);
char *find_trash_can(int predefined_trash_flag, char *match, int custom_trash_flag, char *custom_trash_path);
int getExtension(char *entity_path_after_deletion);
int my_file_copy(char *filepath_before_delete, char *filepath_after_delete);
int my_directory_copy(char *filepath_before_delete, char *filepath_after_delete);
int copy_file(char *source_file, char *destination_file);

int main (int argc, char *argv[]){
  //from http://web.cs.wpi.edu/~cs4513/d14/samples/env.c
  extern char **environ;      /* externally declared */
  char *match;
  //end code from samples/env.c
  
  char *trash_env_name = "TRASH";
  int predefined_trash_flag = 0;
  
  //adapted from http://web.cs.wpi.edu/~cs4513/d14/samples/get-opt.c
  int c;
  int force_flag = 0;
  int directory_flag = 0;
  int custom_trash_flag = 0;
  char *custom_trash_path = NULL;
  char *entity_to_delete = NULL;
  int num_files_to_delete = 0;
  extern int optind, opterr;
  extern char *optarg;
  //end code from samples/get-opt.c
  
  if(argc < 2){
    usage();
  }
  
  //adapted from http://web.cs.wpi.edu/~cs4513/d14/samples/env.c
  match = getenv(trash_env_name);
  if(!match){
    predefined_trash_flag = 0;
    //    printf("No '%s' variable in environment\n", trash_env_name);
  }
  else{
    //predefined trash path contained in "match" variable
    predefined_trash_flag = 1;
  }
  //end code from samples/env.c  
  
  
  //from http://web.cs.wpi.edu/~cs4513/d14/samples/get-opt.c
  opterr = 1; /* set to 0 to disable error message */
  while ((c = getopt (argc, argv, "fhrt:i:")) != EOF) {
    switch (c) {
    case 'f':
      force_flag++;
      break;
    case 'h':
      usage();
      break;
    case 'r':
      directory_flag++;
      printf("-r flag specified. Only one directory name to be removed will be read.\n");
      break;
    case 't':
      custom_trash_flag++;
      custom_trash_path = optarg;
      break;
    case 'i':
      entity_to_delete = optarg;
      process_filename(predefined_trash_flag, match, custom_trash_flag, custom_trash_path, entity_to_delete, directory_flag);
      //printf("%s\n", entity_to_delete);
      num_files_to_delete++;
      break;
    }
  }
  
  /* check whether or not we actually processed something */
  if(num_files_to_delete > 0){
    
  }
  else{
    usage();
  }
  
  //end code from samples/get-opt.c
  
} //end main

int process_filename(int predefined_trash_flag, char *match, int custom_trash_flag, char *custom_trash_path, char *entity_to_delete, int directory_flag){
  int ret_stat; /* return value for the stat call */
  struct stat buf; /* struct to hold file stats */
  
  char *trash_path = find_trash_can(predefined_trash_flag, match, custom_trash_flag, custom_trash_path);
  //we have a trash directory
  //we have at least one entity to delete
  //TODO: ignore -f flag for now
  
  printf("Deleting %s\n", entity_to_delete);
  printf("Trash: %s\n", trash_path);
  
  char *entity_path_after_deletion = (char *)malloc(snprintf(NULL, 0, "%s%s", trash_path, entity_to_delete) + 1);
  char *entity_to_delete_backup = (char *)malloc(strlen(entity_to_delete + 2));
  sprintf(entity_to_delete_backup, "%s", entity_to_delete);
  
  char *filename_to_delete = basename(entity_to_delete_backup);
  printf("filename: %s\n", filename_to_delete);
  printf("entity_to_delete_backup in between: %s\n", entity_to_delete_backup);
  char *directory_containing_file = dirname(entity_to_delete_backup);
  printf("directory: %s\n", directory_containing_file);
  
  /*  char cwd[1024];
      if(getcwd(cwd, sizeof(cwd)) != NULL){
      printf("Current working directory:%s\n", cwd);
      }
      else{
      perror("error getting current working directory:\n");
      }
  */
  
  //TODO: what if removing from trash to trash
  //TODO: what if told to remove the trash directory
  
  chdir(directory_containing_file);
  
  sprintf(entity_path_after_deletion, "%s%s", trash_path, filename_to_delete);
  printf("entity_path_after_deletion: %s\n", entity_path_after_deletion);
  
  //using rename on a directory actually moves all the files in it too! as long as on
  //same filesystem
  
  int extension_number = getExtension(entity_path_after_deletion);
  printf("extension_number:%d\n", extension_number);
  char *entity_path_after_deletion_with_ext = (char *)malloc(strlen(entity_path_after_deletion + 1 + MAX_EXTENSION_VALUE + 1));
  if(extension_number != 0){
    sprintf(entity_path_after_deletion_with_ext, "%s.%d", entity_path_after_deletion, extension_number);
  }
  else{
    sprintf(entity_path_after_deletion_with_ext, "%s", entity_path_after_deletion);
  }
  
  printf("entity_path_after_deletion_with_ext: %s\n", entity_path_after_deletion_with_ext);
  
  /* must specify -r flag if directory */ 
  /* check if file or directory */
  ret_stat = stat(filename_to_delete, &buf);
  if(ret_stat != 0){
    perror("Failed:\n");
    exit(1);
  }
  
  if(S_ISDIR(buf.st_mode)){ /* is a directory */
    //printf("The file is a directory.\n");
    if(directory_flag == 0){
      printf("Filename provided is a directory, but the -r flag is not specified. Exiting...\n");
      exit(2);
    }
  }
  
  /* We know that the filename is either a directory with the -r flag provided, or a file. */
  
  if(rename(filename_to_delete, entity_path_after_deletion_with_ext) == 0){
    //if same partition, this takes care of either a file or a directory with included files (if it succeeds)
  }
  else if(errno == EXDEV){
    //file is on another partition
    printf("The file to delete is on a different partition from the trash directory.\n");
    
    if(S_ISDIR(buf.st_mode)){ /* is a directory */
      //printf("The file is a directory.\n");
      my_directory_copy(filename_to_delete, entity_path_after_deletion_with_ext);
    }
    else{ /* is a file */
      my_file_copy(filename_to_delete, entity_path_after_deletion_with_ext);
    }
  }
  else{
    perror("Error renaming file:");
    printf("errno: %d\n", errno);
    printf("%s\n", strerror(errno));
  }
  
  //free(entity_path_after_deletion);
  //free(entity_to_delete_backup);
  //free(entity_path_after_deletion_with_ext);
  return 0;
}

char *find_trash_can(int predefined_trash_flag, char *match, int custom_trash_flag, char *custom_trash_path){
  //set and print trash can
  char *trash_path = NULL;
  
  int ret_stat; /* return value for the stat call */
  struct stat buf; /* struct to hold file stats */
  
  if(custom_trash_flag > 0){
    if(custom_trash_flag > 1){
      printf("-t flag specified multiple times, last value will be used\n");
    }
    trash_path = custom_trash_path;
  }
  else if(predefined_trash_flag == 1){
    trash_path = match;
  }
  else{
    printf("No predefined TRASH variable, no custom trash path using -t flag, exiting...\n");
    exit(3);
  }
  
  /* have a trash, check if directory */
  ret_stat = stat(trash_path, &buf);
  if(ret_stat != 0){
    perror("Failed:\n");
    exit(1);
  }
  
  if(S_ISDIR(buf.st_mode)){ /* is a directory */
    return trash_path;
  }
  else{
	printf("The specified trash is not a directory. Exiting...\n");
	exit(7);
  }
}


/* print usage and quit */
void usage(void){
  printf( "usage: {-f|-h|-r|-t} [-i <name>]\n");
  exit(4);
}

/* checks if filename exists in trash_directory
   ASSUMES THAT trash_directory IS A DIRECTORY
   returns extension number if file already in trash
   returns 0 if extension not needed
*/
int getExtension(char *entity_path_after_deletion){
  if(access(entity_path_after_deletion, 0) != 0){
    //file does not exist, no extension required, return 0
    return 0;
  }
  
  char *temp_name = (char *) malloc(strlen(entity_path_after_deletion + 1 + MAX_EXTENSION_VALUE + 1));
  int counter = 1;
  
  //printf("before while\n");
  
  while(counter < MAX_EXTENSION_VALUE){
    sprintf(temp_name, "%s.%d", entity_path_after_deletion, counter);
    //printf("after sprintf\n");
    if(access(temp_name, 0) == 0){
      counter++;
    }
    else{
      break;
    }
  }

  //printf("after while\n");
  return counter;
}

int my_file_copy(char *filename_before_delete, char *filename_after_delete){
  printf("In my file copy function\n");
  printf("filename_before_delete:%s\n", filename_before_delete);
  printf("filename_after_delete:%s\n", filename_after_delete);
  int copy_return_code = copy_file(filename_before_delete, filename_after_delete);
  if(copy_return_code == 0){
    if(unlink(filename_before_delete) == 0){
      printf("File copied and unlinked!\n");
      return 0;
    }
    else{
      perror("Unlinking original file failed\n");
    }
  }
  else if(errno == 21){
    //is a directory
    if(unlink(filename_after_delete) == 0)
      my_directory_copy(filename_before_delete, filename_after_delete);
    else
      perror("Recursive copying failed\n");
  }
  else{
    perror("file copy failed \n");
    return -1;
  }
}


//from Tanenbaum's Modern Operating Systems textbook
//from http://web.cs.wpi.edu/~cs4513/d14/samples/stat.c
//from http://web.cs.wpi.edu/~cs4513/d14/samples/touch.c
int copy_file(char *source_file, char *destination_file){
  int in_fd, out_fd, rd_count, wt_count;

  time_t actime = 0, modtime = 0; /* access time, modify time */
  struct utimbuf puttime; /* to set time */
  int errflag = 0;

  int ret_stat; /* return value for the stat call */
  struct stat buf; /* struct to hold file stats */

  ret_stat = stat(source_file, &buf);
  if(ret_stat != 0){
    perror("Failed:\n");
    exit(1);
  }

  puttime.actime = buf.st_atime;
  puttime.modtime = buf.st_mtime;

  char buffer[FILE_COPY_BUF_SIZE];

  /* open the input file and create the output file */
  in_fd = open(source_file, O_RDONLY); /* open the source file */
  if(in_fd < 0) return 5; /* if it cannot be opened, return */
  out_fd = creat(destination_file, FILE_COPY_OUTPUT_MODE); /* create the destination file */
  if(out_fd < 0) return 6; /*if it cannot be created, return */
  
  /* Copy loop */
  while(1){
    rd_count = read(in_fd, buffer, FILE_COPY_BUF_SIZE); /* read a block of data */
    if(rd_count <= 0) break; /* if end of file or error, exit loop */
    wt_count = write(out_fd, buffer, rd_count); /* write data */
    if(wt_count <= 0) return 7; /* wt_count <= 0 is an error */
  }

  /* Close the files */
  close(in_fd);
  close(out_fd);
  if(rd_count == 0){ /* no error on last read */
    /* modify to preserve permissions using stat and utime */
    if(utime(destination_file, &puttime) == -1){ /* preserve time failed */
      perror("utime");
    }
    printf("\tmode: %d\n", buf.st_mode);
    if(chmod(destination_file, buf.st_mode) == -1){ /* preserve permissions failed */
      perror("chmod");
    }
    return 0;
  }
  else{ /* error on last read */
    return 8;
  }
}
//end from Tanenbaum
//end from samples/stat.c
//end from samples/touch.c

int my_directory_copy(char *source_dir, char *destination_dir){
  char arr[FILE_COPY_BUF_SIZE];

  strcpy(arr, destination_dir);

  int ret_stat; /* return value for the stat call */
  int ret_mkdir; /* return value for the mkdir call */
  struct stat buf; /* struct to hold file stats */

  int i_ret_stat; /* return value for the internal stat call */
  struct stat i_buf; /* struct to hold internal file stats */

  //printf("source_dir: %s\n", source_dir);
  //printf("destination_dir: %s\n", destination_dir);
  
  ret_stat = stat(source_dir, &buf);
  if(ret_stat != 0){
    perror("Failed:\n");
    exit(1);
  }
  
  ret_mkdir = mkdir(destination_dir, buf.st_mode);
  if(ret_mkdir == -1){ /* mkdir failed */
    /* if directory name already exists in trash, print error and exit */
    if(errno == EEXIST){
      printf("The directory already exists in the trash folder, exiting.\n");
	  exit(5);
    }
    else{
      perror("mkdir:\n");
    }
  }

  DIR *in_dir = opendir(source_dir);
  //printf("source_dir: %s\n", source_dir);
  //printf("destination_dir: %s\n", arr);
  struct dirent *ent;
  if(in_dir != NULL){
    printf("Contents of the source_dir are:\n");
    
    char *file_to_copy = NULL;
    char *ftc_d = NULL;

    char *file_to_copy_to = NULL;
    char *ftct_d = NULL;
    
    while((ent = readdir(in_dir)) != NULL){
      if(strcmp(ent -> d_name, ".") == 0);
      else if(strcmp(ent -> d_name, "..") == 0);
      else{
	/* check if file or directory */
	//printf("%s\n", ent -> d_name);
	//i_ret_stat = stat(ent -> d_name, &i_buf);
	//if(i_ret_stat != 0){
	//perror("Failed:\n");
	//exit(1);
	//}
	//printf("Got here!\n");
	//if(S_ISDIR(i_buf.st_mode)){ /* is a directory */
	  /* recursively copy sub directories */
	  //my_directory_copy(ent->d_name, arr);
	//}
	//else{	  
	  printf("%s\n", ent -> d_name);
	  ftc_d = (char *) realloc(file_to_copy, strlen(source_dir + 246 + 2));
	  sprintf(ftc_d, "%s/%s", source_dir, ent -> d_name);
	  printf("file_to_copy (ftc_d):%s\n", ftc_d);
	  
	  ftct_d = (char *) realloc(file_to_copy_to, strlen(arr + 246 + 2));
	  sprintf(ftct_d, "%s/%s", arr, ent -> d_name);
	  printf("file_to_copy_to (ftct_d):%s\n", ftct_d);
	  if(my_file_copy(ftc_d, ftct_d) == -1){
	    printf("copy failed, exiting");
	    exit(6);
	  }
	  //}
      }
    }
    //free(file_to_copy);
    //free(file_to_copy_to);
    printf("Done\n");
    if(rmdir(source_dir) == -1){ /* rmdir failed */
      perror("rmdir:\n");
    }
    return 0;
  }
  else{ /* could not open directory */
    perror("opendir:\n");
    return 10;
  }
}
