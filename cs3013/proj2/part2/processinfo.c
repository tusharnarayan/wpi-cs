/* Project 2
 * Cynthia Rogers - cerogers@wpi.edu
 * Tushar Narayan - tnarayan@wpi.edu
 * Part 2 - Checking the implementation of the getprocessinfo system call
 */

#include <sys/syscall.h>
#include <stdio.h>
#include "processinfo.h"
#include <errno.h>

#define __NR_getprocessinfo 342

long getprocessinfo (struct prinfo *info) {
  return (long) syscall(__NR_getprocessinfo, info);
};

void printstats (struct prinfo *info){
  printf("\nMembers:\n");
  printf("state = %ld\n", info -> state);
  printf("pid = %i\n", info->pid);
  printf("parent_pid = %i\n", info->parent_pid);
  printf("youngest_child = %i\n", info->state);
  printf("younger_sibling = %i\n", info->state);
  printf("older_sibling = %i\n", info->state);
  printf("uid = %i\n", info->uid);
  printf("comm = %s\n", info->comm);
  printf("start_time = %lld\n", info->start_time);
  printf("user_time = %lld\n", info->user_time);
  printf("sys_time = %lld\n", info->sys_time);
  printf("cutime = %lld\n", info->cutime);
  printf("cstime = %lld\n", info->cstime);
}

main (){
  struct prinfo info;
  struct prinfo parent_info;
  struct prinfo first_child;
  struct prinfo second_child;
  int cstatus;
  int cstatus2;
  pid_t pid;
  pid_t pid2;
  
  printf("\nThe return code from the getprocessinfo system call is %d\n", getprocessinfo(&info)); 
  pid = fork();
  if (pid == -1){
    printf("Fork failed. Run again %s\n", strerror(errno));
  }
  else if (pid !=0){
    printf("\n\nOriginal parent process before wait\n");
    getprocessinfo(&parent_info);
    printstats(&parent_info);    
    pid2 = fork();
    if(pid2 == -1){
      printf("Second fork broke");
    }
    else if (pid2 !=0){
      printf("\nSecond fork:\n");
      getprocessinfo(&parent_info);
      printstats(&parent_info);
      waitpid(pid2, &cstatus2, 0);
      printf("\n\nParent process after second fork\n");
      getprocessinfo(&parent_info);
      printstats (&parent_info);
    }
    else{
      sleep(1);
      getprocessinfo(&second_child);
      printf("\n\nSecond child info\n");
      printstats(&second_child);
    }
    waitpid(pid, &cstatus, 0);
    printf("\n\nOriginal parent process after wait\n");
    getprocessinfo(&parent_info);
    printstats (&parent_info);
  }
  else{
    sleep(1);
    printf("\n\nFirst child info\n");
    getprocessinfo(&first_child);
    printstats(&first_child);
  }
  printf("\n\nOriginal parent process\n");
  getprocessinfo(&info);
  printstats (&info);
  return 0;
}

//fork stuff, see if parent pids are correct, exhaustive testing
