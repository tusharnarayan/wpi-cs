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

/* function prototypes */
void usage(void);
char *find_trash_can(int predefined_trash_flag, char *match, int custom_trash_flag, char *custom_trash_path);

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
  while ((c = getopt (argc, argv, "ht:")) != EOF) {
    switch (c) {
    case 'h':
      usage();
      break;
    case 't':
      custom_trash_flag++;
      custom_trash_path = optarg;
      break;
    }
  }
    //end code from samples/get-opt.c

  char *trash_path = find_trash_can(predefined_trash_flag, match, custom_trash_flag, custom_trash_path);
  //we know that trash_path is the trash *directory*


  int ret_mkdir; /* return value for the mkdir call */
  int ret_stat; /* return value for the stat call */
  struct stat buf; /* struct to hold file stats */
  time_t actime = 0, modtime = 0; /* access time, modify time */
  struct utimbuf puttime; /* to set time */

  if(stat(trash_path, &buf) == -1) perror("Stat\n");

  puttime.actime = buf.st_atime;
  puttime.modtime = buf.st_mtime;

  delete_directory_and_contents(trash_path);
  printf("%s\n", trash_path);  

  ret_mkdir = mkdir(trash_path, buf.st_mode);

  if(utime(trash_path, &puttime) == -1){ /* preserve time failed */
    perror("utime");
  }
  return 0;

} //end main


int delete_directory_and_contents(char *dir_path){
  char path[1000];
  strcpy(path, dir_path);

  DIR *dh = opendir(dir_path);

  struct stat buf; /* struct to hold file stats */

  char newp[1000];
  struct dirent *ent;
  if(dh != NULL){
    while((ent = readdir(dh)) != NULL){
      if(strcmp(ent -> d_name, ".") == 0) continue;
      if(strcmp(ent -> d_name, "..") == 0) continue;

      strcpy(newp, path);
      strcat(newp, "/");
      strcat(newp, ent->d_name);

      /* check if file or directory */
      printf("%s\n", newp);
       
      if(stat(newp, &buf) == -1) perror("Stat\n");
      
      if(S_ISDIR(buf.st_mode)){ /* is a directory */
	strcat(path, "/");
	strcat(path, ent->d_name);
	delete_directory_and_contents(path);
	strcpy(path, dir_path);
      }
      else{ /* is a file */
	if(remove(newp) == 0){
	  printf("Unlinking worked!\n");
	}
	else{
	  perror("Hi\n");
	}
      }
    }
  }
  closedir(dh);
  rmdir(dir_path);
  return 0;
}

/* print usage and quit */
void usage(void){
  printf( "usage: {-h|-t <path>}\n");
  exit(4);
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
