/*program shell
 *Project 1, Phase 2
 *Cynthia Rogers - cerogers
 *Tushar Narayan - tnarayan
 */

#define TRUE 1
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/resource.h>

struct rusage prev_stats;
long prev_usr_milliseconds;
long prev_sys_milliseconds;

void type_prompt(){
  printf("\nbash: $ ");
}

int read_command(char *command, char *parameters[32]){
  int num_args;
  int i, length = 0;
  int nbytes = 1024;
  char *input_string = (char *) malloc(nbytes + 1);
  char *result;
  char input_char;

  for(i = 0; i < 32; i++) parameters[i] = "";
  int bytes_read;
  char delim[] = " \n";
  bytes_read = getline (&input_string, &nbytes, stdin);
  if(strcmp(input_string, "\n") == 0) return -2;
  if(bytes_read == -1) {
    exit(4);
  }

  //if(i >= 128) printf("Warning - Only first 128 characters of input will be used!\n");
  //reading complete, now to parse
  result = strtok(input_string, delim);
  while(result != NULL){
    parameters[length]=result;
    length++;
    result = strtok(NULL, delim);
  }
  return length;
}

void print_statistics(){
  struct rusage stats;
  struct timeval sys_time;
  struct timeval usr_time;
  if(getrusage (RUSAGE_CHILDREN, &stats) == -1) printf("getrusage failed\n");
  sys_time = stats.ru_stime;
  usr_time = stats.ru_utime;
  long usr_milliseconds = usr_time.tv_sec*1000 + usr_time.tv_usec*0.001;
  long sys_milliseconds = sys_time.tv_sec*1000 + sys_time.tv_usec*0.001;
  printf ("\nUser CPU time:\n%ld millisecconds\n",usr_milliseconds - prev_usr_milliseconds);
  printf ("\nSystem CPU time:\n%ld millisecconds\n",sys_milliseconds - prev_sys_milliseconds);
  printf ("\nNumber of times the process was preempted involuntarily:\n%ld\n",stats.ru_nivcsw - prev_stats.ru_nivcsw);
  printf ("\nNumber of times the process gave up the CPU voluntarily:\n%ld\n",stats.ru_nvcsw - prev_stats.ru_nvcsw);
  printf ("\nNumber of hard page faults:\n%ld\n",stats.ru_majflt - prev_stats.ru_majflt);
  printf ("\nNumber of page faults that could be satisfied using unreclaimed pages:\n%ld\n",stats.ru_minflt - prev_stats.ru_minflt);
  prev_usr_milliseconds = usr_milliseconds;
  prev_sys_milliseconds = sys_milliseconds;
  prev_stats.ru_nivcsw = stats.ru_nivcsw;
  prev_stats.ru_nvcsw = stats.ru_nvcsw;
  prev_stats.ru_majflt = stats.ru_majflt;
  prev_stats.ru_minflt = stats.ru_minflt;
}

void interactive(){
   while (TRUE){
    char *command;
    int i;
    char *parameters[32];
    struct timeval initial_clock;
    struct timeval final_clock;    
    int num_params;

    do{
      type_prompt();// displays prompt
      num_params = read_command(command, parameters);//get input from user and parse it into command and parameters
      if(num_params > 32){
	printf("\nOnly 32 arguments allowed.\n");
      }
    } while(num_params > 32 || num_params == -2);
    char **params = malloc((num_params + 1) * sizeof(char *));
    for(i = 0; i < num_params; i++)
      params[i] = parameters[i];
    params[i] = NULL;
    command = params[0];
    if(strcmp("exit", command) == 0) exit(4);
    if(strcmp("cd", command) == 0){
      chdir(params[1]);
      continue;
    }
    if(gettimeofday(&initial_clock, NULL) == -1) printf("\nCould not get time.\n");
    pid_t pId = fork();
    if(pId == -1){ //fork failed
      printf("Fork failed. Please try running again. %s\n", strerror(errno));
    }
    if(pId != 0){ //parent process
      int status;
      if(waitpid(pId,&status, 0) != pId) printf("waitpid failed\n");
      
      // once child process is done, print usage statistics
      if(gettimeofday(&final_clock, NULL) == -1) printf("\nCould not get time.\n");
      long seconds_elapsed = final_clock.tv_sec - initial_clock.tv_sec;
      long microseconds_elapsed = final_clock.tv_usec - initial_clock.tv_usec;
      long milliseconds_elapsed = seconds_elapsed*1000 + microseconds_elapsed*0.001;
      printf("\nWall clock time for the command to execute:\n%ld milliseconds\n", milliseconds_elapsed);
      print_statistics();
    }
    else{ //child process
      int returnnum;
      returnnum = execvp(command, params);
      if(returnnum == -1){ //error occurred during execvp
	printf("Your command didn't work: %s\n", strerror(errno));
	prev_usr_milliseconds = 0;
	prev_sys_milliseconds = 0;
	prev_stats.ru_nivcsw = 0;
	prev_stats.ru_nvcsw = 0;
	prev_stats.ru_majflt = 0;
	prev_stats.ru_minflt = 0;
      }
    }
  }
}

void non_interactive(){
  while (TRUE){
    char *command;
    int i;
    char *parameters[32];
    struct timeval initial_clock;
    struct timeval final_clock;    
    int num_params;

    do{
      num_params = read_command(command, parameters);//get input from user and parse it into command and parameters
      if(num_params > 32){
	printf("\nOnly 32 arguments allowed.\n");
      }
    } while(num_params > 32);
    char **params = malloc((num_params + 1) * sizeof(char *));
    for(i = 0; i < num_params; i++)
      params[i] = parameters[i];
    params[i] = NULL;
    command = params[0];
    if(strcmp("exit", command) == 0) exit(4);
    if(strcmp("cd", command) == 0){
      chdir(params[1]);
      continue;
    }
    if(gettimeofday(&initial_clock, NULL) == -1) printf("\nCould not get time.\n");
    pid_t pId = fork();
    if(pId == -1){ //fork failed
      printf("Fork failed. Please try running again. %s\n", strerror(errno));
    }
    if(pId != 0){ //parent process
      int status;
      if(waitpid(pId,&status, 0) != pId) printf("waitpid failed\n");
      
      // once child process is done, print usage statistics
      if(gettimeofday(&final_clock, NULL) == -1) printf("\nCould not get time.\n");
      long seconds_elapsed = final_clock.tv_sec - initial_clock.tv_sec;
      long microseconds_elapsed = final_clock.tv_usec - initial_clock.tv_usec;
      long milliseconds_elapsed = seconds_elapsed*1000 + microseconds_elapsed*0.001;
      printf("\nWall clock time for the command to execute:\n%ld milliseconds\n", milliseconds_elapsed);
      print_statistics();
    }
    else{ //child process
      int returnnum;
      returnnum = execvp(command, params);
      if(returnnum == -1){ //error occurred during execvp
	printf("Your command didn't work: %s\n", strerror(errno));
	prev_usr_milliseconds = 0;
	prev_sys_milliseconds = 0;
	prev_stats.ru_nivcsw = 0;
	prev_stats.ru_nvcsw = 0;
	prev_stats.ru_majflt = 0;
	prev_stats.ru_minflt = 0;
	continue;
      }
    }
  }
}

int main (){
  prev_usr_milliseconds = 0;
  prev_sys_milliseconds = 0;
  prev_stats.ru_nivcsw = 0;
  prev_stats.ru_nvcsw = 0;
  prev_stats.ru_majflt = 0;
  prev_stats.ru_minflt = 0;
  if (isatty(STDIN_FILENO)==0){
    non_interactive();
  }
  else {
    interactive();
  }
  // free(params);
}
