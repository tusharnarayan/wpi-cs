/*
Used http://web.cs.wpi.edu/~jb/CS3516/Project1/Project1_Starter_Client.c

Also used http://web.cs.wpi.edu/~jb/CS3516/Project1/AddressTranslation.c

connect to Apache on port 80
connect to my server on any other port (preferably a higher port number like 6789)

*/

#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <arpa/inet.h>

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
  int bytes_read;
  
  if (argc < 4) {
    printf( "The program expects three arguments\n" );
    printf( "./Browser <server-url> <port number> <target file>\n" );
    exit(0);
  }
  
  server_url = argv[1];
  port_number = atoi(argv[2]);
  filename = argv[3];

  //code from http://web.cs.wpi.edu/~jb/CS3516/Project1/AddressTranslation.c
  //translates address between hostname and an ip address

  char *ptr, **pptr;
  char str[INET6_ADDRSTRLEN];
  struct hostent *hptr;
  char IPAddress[100];

  ptr = *++argv; // Get the argument after the program name
  if ( (hptr = gethostbyname(ptr)) == NULL) {
    printf("gethostbyname error for host: %s: %s\n",
	   ptr, hstrerror(h_errno));
    exit(0);
  }
  printf("official hostname: %s\n", hptr->h_name);

  // Are there other names for this site?
  for (pptr = hptr->h_aliases; *pptr != NULL; pptr++) {
    printf("    alias: %s\n", *pptr);
  }
  pptr = hptr->h_addr_list;   // Assumes address type is AF_INET
  for ( ; *pptr != NULL; pptr++) {
    strcpy( IPAddress,  inet_ntop(hptr->h_addrtype, 
				  *pptr, str, sizeof(str)));
    printf("\taddress: %s\n", IPAddress );

    // For each of the IP addresses, find the host address
    if ( (hptr = gethostbyaddr(*pptr, hptr->h_length,
			       hptr->h_addrtype)) == NULL)
      printf("\t(gethostbyaddr failed)\n");
    else if (hptr->h_name != NULL)
      printf("\tname = %s\n", hptr->h_name);
    else
      printf("\t(no hostname returned by gethostbyaddr)\n");
  }             // End of for loop
  
  //end of code from http://web.cs.wpi.edu/~jb/CS3516/Project1/AddressTranslation.c

  port = htons(port_number); //convert unsigned integer from host byte order to network byte order

  //set up the socket
  if ((fd = socket (family, type, 0)) < 0) {
    printf("Error in the socket call!");
    exit(1);
  }
  
  // set up the sockaddr_in structure
  bzero(&sa, sizeof(sa));
  sa.sin_family = family;
  sa.sin_port = port; /* client & server see same port*/
  sa.sin_addr = *((struct in_addr *)hptr -> h_addr); 

  //connect to socket
  if (connect(fd, (struct sockaddr *) &sa, sizeof(sa))){
    printf("Error: the connect call failed!");
    exit(1);
  }
  
  //zero out the output buffer
  bzero(ip_output_buffer, sizeof(ip_output_buffer));

  //store message in output buffer
  sprintf(ip_output_buffer, "GET /%s HTTP/1.0\r\nHost: %s:%d\r\n\r\n", filename, server_url, port_number);

  //write to socket
  if (write(fd, ip_output_buffer, strlen(ip_output_buffer)) <= 0) {
    printf("Error in the write call!");
    exit(1);
  }
  
  //zero out the input buffer
  bzero(ip_input_buffer, sizeof(ip_input_buffer));
  
  while(1){
    //read from socket
    bytes_read = recv(fd, ip_input_buffer, sizeof(ip_input_buffer) - 2, 0);

    if(bytes_read == -1){
	printf("\nError in the recv call!\n");
	exit(1);
      }
    else if(bytes_read ==0){
      printf("\nServer closed the connection.\n");
      break;
    }
    else{
      printf( "%s", ip_input_buffer );
    }
    bzero(ip_input_buffer, sizeof(ip_input_buffer));
  }
  
  close(fd);
  return 0;
}                                       /* End of main          */
