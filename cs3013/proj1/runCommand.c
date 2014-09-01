/*program runCommand
 *Project 1, Phase 1
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

int main (int argc, char* argv[]){
  if (argc == 1){//handling incorrect usage
    printf("You did not specify any command to run. Please try again.\n\
");
    printf("Usage:\t./runCommand <command> [parameters]\n");
    printf("Example:\t./runCommand ls /home \t will list the contents o\
f the home directory.\n");
    exit(1); //1 is the error code for no parameters
  }

  char *command = argv[1];
  struct timeval initial_clock;
  struct timeval final_clock;
  struct rusage stats;
  struct timeval sys_time;
  struct timeval usr_time;

  //const char *pathenv = "PATH";
  //char *pathvar = getenv(pathenv);
  //printf(pathvar);

  if(gettimeofday(&initial_clock, NULL) == -1) printf("\nCould not get time.\n");

  pid_t pId = fork();
  if(pId == -1){ //fork failed
    printf("Fork failed. Please try running again. %s\n", strerror(errn\
o));
  }
  if(pId != 0){ //parent process
    int status;
    if(waitpid(pId,&status, 0) != pId) printf("waitpid failed\n");
    // once child process is done, print usage statistics
    if(gettimeofday(&final_clock, NULL) == -1) printf("\nCould not get time.\n");
    long seconds_elapsed = final_clock.tv_sec - initial_clock.tv_sec;
    long microseconds_elapsed = final_clock.tv_usec - initial_clock.tv_usec;
    long milliseconds_elapsed = seconds_elapsed*1000 + microseconds_elapsed*0.001;
    if(getrusage (RUSAGE_CHILDREN, &stats) == -1) printf("getrusage fai\
led\n");
    sys_time = stats.ru_stime;
    usr_time = stats.ru_utime;
    long usr_millisecconds = usr_time.tv_sec*1000 + usr_time.tv_usec*0.001;
    long sys_millisecconds = sys_time.tv_sec*1000 + sys_time.tv_usec*0.001;
    printf("\nWall clock time for the command to execute:\n%ld milliseconds\n", milliseconds_elapsed);
    printf ("\nUser CPU time:\n%ld millisecconds\n",usr_millisecconds);
    printf ("\nSystem CPU time:\n%ld millisecconds\n",sys_millisecconds)\
;
    printf ("\nNumber of times the process was preempted involuntarily:\
\n%ld\n",stats.ru_nivcsw);
    printf ("\nNumber of times the process gave up the CPU voluntarily:\
\n%ld\n",stats.ru_nvcsw);
    printf ("\nNumber of hard page faults:\n%ld\n",stats.ru_majflt);
    printf ("\nNumber of page faults that could be satisfied using unre\
claimed pages:\n%ld\n",stats.ru_minflt);
  }
  else{ //child process
    int returnnum;
    char *parameters[argc];
    int i, j;
    for(i = 0, j = 1; i < argc - 1; i++, j++) parameters[i] = argv[j];
    parameters[i] = NULL;
    returnnum = execvp(command, parameters);
    if(returnnum == -1){ //error occurred during execvp
      printf("Error opening file: %s\n", strerror(errno));
    }
  }
}
