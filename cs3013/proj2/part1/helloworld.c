/* Project 2
 * Cynthia Rogers - cerogers@wpi.edu
 * Tushar Narayan - tnarayan@wpi.edu
 * Part 1 - Checking the implementation of the helloworld system call
 */

#include <sys/syscall.h>
#include <stdio.h>

#define __NR_helloworld 341

long helloworld (void) {
  return (long) syscall(__NR_helloworld);
};

main (){
  printf("\nThe return code from the helloworld system call is %d\n", helloworld());
  return 0;
}
