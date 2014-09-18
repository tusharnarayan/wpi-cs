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

//from Tanenbaum's Modern Operating Systems textbook
#define FILE_COPY_BUF_SIZE 4096 /* use a buffer size of 4096 bytes */
#define FILE_COPY_OUTPUT_MODE 0700 /* protection bits for output file */
//end from Tanenbaum

/* function prototypes */
void usage(void);
char *find_trash_can(int predefined_trash_flag, char *match, int custom_trash_flag, char *custom_trash_path);
int process_filename(int predefined_trash_flag, char *match, int custom_trash_flag, char *custom_trash_path, char *entity_to_undelete);
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
  int custom_trash_flag = 0;
  char *custom_trash_path = NULL;
  char *entity_to_undelete = NULL;
  int num_files_to_undelete = 0;
  extern int optind, opterr;
  //end code from samples/get-opt.c

  //adapted from http://web.cs.wpi.edu/~cs4513/d14/samples/env.c
  match = getenv(trash_env_name);
  if(!match){
    predefined_trash_flag = 0;
  }
  else{
    //predefined trash path contained in "match" variable
    predefined_trash_flag = 1;
  }
  //end code from samples/env.c  
  
  
  //from http://web.cs.wpi.edu/~cs4513/d14/samples/get-opt.c
  opterr = 1; /* set to 0 to disable error message */
  while ((c = getopt (argc, argv, "ht:i:")) != EOF) {
    switch (c) {
    case 'h':
      usage();
      break;
    case 't':
      custom_trash_flag++;
      custom_trash_path = optarg;
      break;
	case 'i':
	entity_to_undelete = optarg;
	process_filename(predefined_trash_flag, match, custom_trash_flag, custom_trash_path, entity_to_undelete);
	num_files_to_undelete++;
    }
  }
    //end code from samples/get-opt.c
} //end main

int process_filename(int predefined_trash_flag, char *match, int custom_trash_flag, char *custom_trash_path, char *entity_to_undelete){
  char *trash_path = find_trash_can(predefined_trash_flag, match, custom_trash_flag, custom_trash_path);
  /* we know the trash path is the path to a directory */
  
  
 
  //TODO: if doesn't exist in trash
  //--print error, exit

  char path_to_entity_before_undelete[1024];
  strcpy(path_to_entity_before_undelete, trash_path);
  strcat(path_to_entity_before_undelete, "/");
  strcat(path_to_entity_before_undelete, entity_to_undelete);
  
  struct stat buf; /* struct to hold file stats */
  if(stat(path_to_entity_before_undelete, &buf) != 0){
    perror("Stat:/n");
    exit(1);
  }  
  
  char cwd[1024];
  if(getcwd(cwd, sizeof(cwd)) != NULL){
    printf("Current working directory:%s\n", cwd);
  }
  else{
    perror("error getting current working directory:\n");
  }
  
  char path_to_entity_after_undelete[1024];
  strcpy(path_to_entity_after_undelete, cwd);
  strcat(path_to_entity_after_undelete, "/");
  strcat(path_to_entity_after_undelete, entity_to_undelete);
  
  printf("here \n%s\nand\n%s\n", path_to_entity_before_undelete, path_to_entity_after_undelete);
  
  if(rename(path_to_entity_before_undelete, path_to_entity_after_undelete) == 0){
    /* takes care of files and directory on same filesystem */
  }
  else if(errno == EXDEV){ /* entity to undelete is on another partition */
    if(S_ISDIR(buf.st_mode)){ /* is a directory */
      printf("calling my directory copy with \n%s\nand\n%s\n", path_to_entity_before_undelete, path_to_entity_after_undelete);
      my_directory_copy(path_to_entity_before_undelete, path_to_entity_after_undelete);
    }
    else{ /* is a file */
      printf("calling my file copy with \n%s\nand\n%s\n", path_to_entity_before_undelete, path_to_entity_after_undelete);
      my_file_copy(path_to_entity_before_undelete, path_to_entity_after_undelete);
    }
  }
  else{
    perror("Rename:\n");
  }
  
  return 0;
}


char *find_trash_can(int predefined_trash_flag, char *match, int custom_trash_flag, char *custom_trash_path){
  //set and print trash can
  char *trash_path = NULL;
  
  int ret_stat; /* return value for the stat call */
  struct stat buf; /* struct to hold file stats */
  
  if(custom_trash_flag > 0){
    if(custom_trash_flag > 1){
      //printf("-t flag specified multiple times, last value will be used\n");
    }
    trash_path = custom_trash_path;
  }
  else if(predefined_trash_flag == 1){
    trash_path = match;
  }
  else{
    fprintf(stderr, "No predefined TRASH variable, no custom trash path using -t flag, exiting...\n");
    exit(3);
  }
  
  /* have a trash path, check if directory */
  ret_stat = stat(trash_path, &buf);
  if(ret_stat != 0){
    perror("Failed:\n");
    exit(1);
  }
  
  if(S_ISDIR(buf.st_mode)){ /* is a directory */
    return trash_path;
  }
  else{
    fprintf(stderr, "The specified trash is not a directory. Exiting...\n");
    exit(7);
  }
}


/* print usage and quit */
void usage(void){
  printf( "usage: {-h|-t} [-i <name>]\n");
  exit(4);
}

int my_file_copy(char *filename_before_delete, char *filename_after_delete){
  printf("In my file copy\n");
  printf("filename_before_delete:%s\n", filename_before_delete);
  printf("filename_after_delete:%s\n", filename_after_delete);
  int copy_return_code = copy_file(filename_before_delete, filename_after_delete);
  if(copy_return_code == 0){
    if(unlink(filename_before_delete) == 0){
      //printf("File copied and unlinked!\n");
      return 0;
    }
    else{
      perror("Unlinking original file failed\n");
    }
  }
  /*else if(errno == 21){
  //is a directory
  if(unlink(filename_after_delete) == 0){
  my_directory_copy(filename_before_delete, filename_after_delete);
  }
  else{
  perror("Recursive copying failed\n");
  }
  }
  */
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
  printf("In my directory copy\n");
  char src_path[1000];
  strcpy(src_path, source_dir);
  char dst_path[1024];
  strcpy(dst_path, destination_dir);
  
  char arr[1024];
  strcpy(arr, destination_dir);
  
  int ret_stat; /* return value for the stat call */
  int ret_mkdir; /* return value for the mkdir call */
  struct stat buf; /* struct to hold file stats */
  
  struct stat i_buf; /* struct to hold internal file stats */
  
  time_t actime = 0, modtime = 0; /* access time, modify time */
  struct utimbuf puttime; /* to set time */
  
  printf("source_dir: %s\n", source_dir);
  printf("destination_dir: %s\n", destination_dir);
  
  ret_stat = stat(source_dir, &buf);
  if(ret_stat != 0){
    perror("Stat failed:\n");
    exit(1);
  }
  
  puttime.actime = buf.st_atime;
  puttime.modtime = buf.st_mtime;
  
  ret_mkdir = mkdir(destination_dir, buf.st_mode);
  if(ret_mkdir == -1){ /* mkdir failed */
    /* if directory name already exists in trash, print error and exit */
    if(errno == EEXIST){
      fprintf(stderr, "The directory already exists in the current folder, exiting.\n");
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
  
  char new_src_path[1000];
  char new_dst_path[1000];
  
  char *entity_name = basename(destination_dir);
  printf("entity name %s \n", entity_name);
  
  if(in_dir != NULL){
    //printf("Contents of the source_dir are:\n");
    
    char *file_to_copy = NULL;
    char *ftc_d = NULL;
    
    char *file_to_copy_to = NULL;
    char *ftct_d = NULL;
    
    while((ent = readdir(in_dir)) != NULL){
      if(strcmp(ent -> d_name, ".") == 0) continue;
      if(strcmp(ent -> d_name, "..") == 0) continue;
      
      strcpy(new_src_path, src_path);
      strcat(new_src_path, "/");
      strcat(new_src_path, ent->d_name);
      strcpy(new_dst_path, dst_path);
      strcat(new_dst_path, "/");
      strcat(new_dst_path, ent->d_name);
      
      /* check if file or directory */
      if(stat(new_src_path, &i_buf) == -1) perror("Stat\n");
      
      strcat(src_path, "/");
      strcat(src_path, ent->d_name);
      
      strcat(dst_path, "/");
      strcat(dst_path, ent->d_name);
      
      if(S_ISDIR(i_buf.st_mode)){ /* is a directory */
	/* recursively copy sub directories */
	my_directory_copy(src_path, dst_path);
	strcpy(src_path, source_dir);
	strcpy(dst_path, arr);
      }
      else{
	if(my_file_copy(src_path, dst_path) == -1){
	  fprintf(stderr, "copy failed, exiting");
	  exit(6);
	}
      }
    }
    //free(file_to_copy);
    //free(file_to_copy_to);
    //printf("Done\n");
    //TODO: close the directory before removing?
    //closedir(in_dir);
    if(rmdir(source_dir) == -1){ /* rmdir failed */
      perror("rmdir:\n");
    }
    
    
    printf("%s\n", dst_path);
    
    /* preserve access times for the directory */
    if(utime(dst_path, &puttime) == -1){ /* preserve time failed */
      perror("utime");
    }
  }
  else{ /* could not open directory */
    perror("opendir:\n");
    return 10;
  }
  
  return 0;
}
