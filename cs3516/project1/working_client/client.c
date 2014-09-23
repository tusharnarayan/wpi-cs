/*Project1_Starter_Client.c

     Does the sequence required to send to the server:
       socket(),  connect(), send().
     Receives from the server:
       recv()  - note that the server may send it's data in multiple
                 packets so you should do recv() as long as data is available.
     Prints out whatever is received.

   You can use port 80 to get to an apache web server, or some
   other port number to test your own server.

*/

#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>

#define BUFFER_SIZE 2000

main(int argc, char *argv[]){
  int family = AF_INET;       /* The default for most cases */
  int type   = SOCK_STREAM;   /* Says it's a TCP connection */
  in_port_t port;
  struct sockaddr_in sa;
  int fd;
  char ip_input_buffer[BUFFER_SIZE];
  char ip_output_buffer[BUFFER_SIZE];
  
  char *server_url;
  int port_number;
  char *filename;
  
  if (argc < 4) {
    printf( "The program expects three arguments\n" );
    printf( "./Browser <server-url> <port number> <target file>\n" );
    exit(0);
  }
  
  server_url = argv[1];
  port_number = atoi(argv[2]);
  filename = argv[3];
  
  port = htons(port_number);  

  if ((fd = socket (family, type, 0)) < 0) {
    printf("Error in the socket call!");
  }
  
  // set up the sockaddr_in structure.  This uses, among other things the 
  // port you've just entered.
  bzero(&sa, sizeof(sa));
  sa.sin_family = family;
  sa.sin_port = port; /* client & server see same port*/
  sa.sin_addr.s_addr = htonl(INADDR_ANY); /* the kernel assigns the IP addr*/

  inet_aton(server_url, &sa.sin_addr);
  
  if (connect(fd, (struct sockaddr *) &sa, sizeof(sa))){
    printf("Error: the connect call failed!");
  }
  
  //bzero(ip_output_buffer, sizeof(ip_output_buffer));
  
  if (write(fd, filename, strlen(filename)) <= 0) {
    printf("Error in the send call!");
  }
  
  if (write(fd, "\n", 1) <= 0) {
    printf("Error in the send call!");
  }
  
  bzero(ip_input_buffer, sizeof(ip_input_buffer));
  
  while(1)
    {
      if ( recv( fd, ip_input_buffer, sizeof(ip_input_buffer) - 2, 0 ) <= 0 ){
	//TODO check if the server closed the connection
	printf("Error in the recv call!");
      }
      printf( "%s", ip_input_buffer );
    }
  
  close(fd);
  return 0;
}                                       /* End of main          */
