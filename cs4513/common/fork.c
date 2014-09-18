#include<stdio.h>

main() {
  
  int pid;			/* process id */

  pid = fork();
  if (pid == 0) {

    puts("I am the child");

  } else {

    puts("I am the parent");

  }

  /* what else might happen above? */

}
