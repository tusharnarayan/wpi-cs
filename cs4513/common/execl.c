#include<stdio.h>

main() {

  /* let's just be an ls program */

  execl("/bin/ls", "/bin/ls", "-l", NULL);

  /* is this line every reached?  if yes, when? */

}
