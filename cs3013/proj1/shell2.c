/*program shell
 *Project 1, Phase 2
 *Cynthia Rogers - cerogers
 *Tushar Narayan - tnarayan
 */

#define TRUE 1
#define FALSE !TRUE

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/resource.h>

typedef struct bj{
  pid_t b_pid;
  int b_jid;
  char* b_cmd;
  struct bj* b_next;
  struct bj* b_prev;
}b_job;

static b_job* bj_start = NULL;
static b_job* bj_end = NULL;

static int bj_amount = 0;

static struct rusage prev_stats;
static long prev_usr_milliseconds;
static long prev_sys_milliseconds;

static int has_bg_process = FALSE;

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

void new_node(pid_t PID, char* cmd){
  ++bj_amount;
  b_job *bj_node = (b_job*) malloc(sizeof(b_job));
  bj_node -> b_pid = PID;
  bj_node -> b_jid = bj_amount;
  bj_node -> b_cmd = (char *) malloc((strlen(cmd) + 1) * sizeof(char));
  bj_node -> b_cmd = cmd;
  bj_node -> b_next = NULL;
  bj_node -> b_prev = NULL;
  if(bj_start == NULL){ //no jobs in list
    bj_node -> b_prev = bj_end;
    bj_start = bj_node;
    bj_end = bj_node;
  }
  else{ //there are jobs in the list
    b_job *last_node = bj_end;
    last_node -> b_next = bj_node;
    bj_node -> b_prev = last_node;
    bj_end = bj_node;
  }  
}

void delete_node (pid_t PID){
  //iterate through the linked list of jobs to find that PID
  b_job *leap_frog;
  leap_frog = bj_start;
  while (leap_frog != NULL){
    if(leap_frog -> b_pid == PID){
      if((leap_frog->b_next != NULL) && ((leap_frog->b_next) ->b_prev != NULL))
	(leap_frog->b_next) ->b_prev = leap_frog->b_prev;
      if((leap_frog->b_prev != NULL) && ((leap_frog->b_prev)->b_next != NULL))
	(leap_frog->b_prev)->b_next = leap_frog->b_next;
      if(leap_frog -> b_prev == NULL && bj_start != NULL) bj_start = leap_frog -> b_next;
      if(leap_frog -> b_next == NULL && bj_end != NULL) bj_end = leap_frog -> b_prev;
      // maybe free later
      break;
    }
    else{
      leap_frog = leap_frog ->b_next;      
    } 
  }
  if (leap_frog == NULL){
    //pid is bad
    printf("error!\n");
  }
}

void print_job_list(){
  if((bj_start == NULL) || (has_bg_process == FALSE)){
    printf("\nNo jobs running in background.\n");
  }
  else{
    printf ("\nJobs running:\n");
    b_job *counter = (b_job*) malloc(sizeof(b_job));
    counter = bj_start;
    while(counter != NULL){
      printf("\n[%d]\t%d\t%s\n", counter -> b_jid, counter -> b_pid, counter -> b_cmd);
      counter = counter -> b_next; 
    }
    free (counter);
  }
}

void background_execution(char* cmd, char** pmtr, int len){
  int i,stat, wait_counter; 
  pid_t ch_pid;
  ch_pid = fork();

  if(ch_pid == -1){ //fork failed
    printf("Fork failed for %s. Please try running again. %s\n", cmd,strerror(errno));
    
  }
  else if (ch_pid != 0){// parent
    new_node (ch_pid, cmd);
    printf("[%d]\t%d\t%s\n", bj_amount, ch_pid, cmd);
    while(TRUE){
      wait_counter = waitpid(-1, &stat, WNOHANG);
      printf("wait counter\t%d\n", wait_counter);
      if(wait_counter == -1) printf("Command %s didn't work: %s\n", cmd, strerror(errno));
      else if(wait_counter == 0) {
	return;
      }
      else{
	//child returned
	print_statistics();
	delete_node(wait_counter);
      }
    }
    return;
  }
  else{//child process
    printf("\nA child process has returned:\n");
    // printf("[%d]\t%d\t%s completed.", jid, 
    int returnnum;
    returnnum = execvp(cmd, pmtr);
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

void interactive(){
   while (TRUE){
    char *command;
    int i;
    char *parameters[32];
    struct timeval initial_clock;
    struct timeval final_clock;    
    int num_params;
    int b_status;

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

    if(strcmp(params[num_params - 1],"&") == 0){
      //background process
      params[num_params - 1] = NULL;
      background_execution(command, params, num_params+1);
      has_bg_process = TRUE;
      continue;
    }
    else{
      if(bj_start == NULL) has_bg_process = FALSE;
    }
    if (strcmp ("jobs", command) == 0){
      print_job_list();
      continue;
    }
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
      
      if(has_bg_process == TRUE){
	int child_back = waitpid(-1, &b_status, 0);
	if(child_back == -1);
	else if(child_back == 0) ;
	else{
	  print_statistics();
	  delete_node(child_back);
	}
      }

      // once child process is done, print usage statistics
      if(gettimeofday(&final_clock, NULL) == -1) printf("\nCould not get time.\n");
      long seconds_elapsed = final_clock.tv_sec - initial_clock.tv_sec;
      long microseconds_elapsed = final_clock.tv_usec - initial_clock.tv_usec;
      long milliseconds_elapsed = seconds_elapsed*1000 + microseconds_elapsed*0.001;
      printf("\nWall clock time for the command to execute:\n%ld milliseconds\n", milliseconds_elapsed);
      print_statistics();
    }
    else{ //child process
      if(has_bg_process == TRUE){
	int child_back = waitpid(-1, &b_status, 0);
	if(child_back == -1);
	else if(child_back == 0) ;
	else{
	  printf("pid: %d\n", child_back);
	  print_statistics();
	  delete_node(child_back);
	}
      }
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
    int b_status;

    do{
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
    printf("\nCommand is:\t%s\n\n", command);
    if(strcmp(params[num_params - 1],"&") == 0){
      //background process
      params[num_params - 1] = NULL;
      background_execution(command, params, num_params+1);
      has_bg_process = TRUE;
      continue;
    }
    else{
      if(bj_start == NULL) has_bg_process = FALSE;
    }
    
    if (strcmp ("jobs", command) == 0){
      print_job_list();
      continue;
    }
    if(strcmp("exit", command) == 0) {
      if(bj_start == NULL && bj_end == NULL)
	exit(4);
      else{
	printf("You still have background jobs running!\n");
	int return_status = 0;
	int status;
	while(return_status != -1){
	  return_status = waitpid(-1, &status, 0);
	  print_statistics();
	  delete_node(return_status);
	}
	exit(0);
      }
    }
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
      
      if(has_bg_process == TRUE){
	int child_back = waitpid(-1, &b_status, 0);
	if(child_back == -1);
	else if(child_back == 0) ;
	else{
	  print_statistics();
	  delete_node(child_back);
	}
      }

      // once child process is done, print usage statistics
      if(gettimeofday(&final_clock, NULL) == -1) printf("\nCould not get time.\n");
      long seconds_elapsed = final_clock.tv_sec - initial_clock.tv_sec;
      long microseconds_elapsed = final_clock.tv_usec - initial_clock.tv_usec;
      long milliseconds_elapsed = seconds_elapsed*1000 + microseconds_elapsed*0.001;
      printf("\nWall clock time for the command to execute:\n%ld milliseconds\n", milliseconds_elapsed);
      print_statistics();
    }
    else{ //child process
      if(has_bg_process == TRUE){
	int child_back = waitpid(-1, &b_status, 0);
	if(child_back == -1);
	else if(child_back == 0) ;
	else{
	  printf("pid: %d\n", child_back);
	  print_statistics();
	  delete_node(child_back);
	}
      }
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
