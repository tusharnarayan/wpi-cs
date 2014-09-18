/*
Used http://web.cs.wpi.edu/~jb/CS3516/Project1/Project1_Starter_Client.c

Also used http://web.cs.wpi.edu/~jb/CS3516/Project1/AddressTranslation.c

connect to Apache on port 80
connect to my server on any other port (preferably a higher port number like 6789)

*/

#define _XOPEN_SOURCE

#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <ctype.h>
#include <strings.h>

#define BUFFER_SIZE 1024
#define DEFAULT_PORT 7778

#define USERNAME "john"
#define PASSWORD "test_password"

void usage();

int main(int argc, char *argv[]){
  int family = AF_INET;       /* The default for most cases */
  int type   = SOCK_STREAM;   /* Says it's a TCP connection */
  in_port_t port;
  struct sockaddr_in sa;
  int fd;
  char ip_input_buffer[BUFFER_SIZE];
  char ip_output_buffer[BUFFER_SIZE];
  
  char *server_url;
  int port_number;
  char *command;
  int bytes_read, hash_bytes_read;

  int c;
  int cflag = 0, sflag = 0, pflag = 0;
  extern int optind, opterr;
  extern char *optarg;

  while((c = getopt (argc, argv, "hc:s:p:")) != EOF){
    switch(c){
    case 'c':
      command = optarg;
      cflag++;
      break;
    case 's':
      server_url = optarg;
      sflag++;
      break;
    case 'p':
      port_number = atoi(optarg);
      pflag++;
      break;
    case 'h':
      usage();
    }
  } 
  
  //  server_url = argv[1];
  //  port_number = atoi(argv[2]);
  //  filename = argv[3];
  
  if(cflag == 0 || sflag == 0){ /* need both command and server_url */
    usage();
  }
  if(pflag == 0){
    //printf("Using default port of %d\n", DEFAULT_PORT);
    port_number = DEFAULT_PORT;
  }
  
  //code from http://web.cs.wpi.edu/~jb/CS3516/Project1/AddressTranslation.c
  //translates address between hostname and an ip address
  
  char *ptr, **pptr;
  char str[INET6_ADDRSTRLEN];
  struct hostent *hptr;
  char IPAddress[100];
  
  //  ptr = *++argv; // Get the argument after the program name
  ptr = server_url;
  if ( (hptr = gethostbyname(ptr)) == NULL) {
    printf("gethostbyname error for host: %s: %s\n",
	   ptr, hstrerror(h_errno));
    exit(0);
  }
  //printf("official hostname: %s\n", hptr->h_name);
  
  // Are there other names for this site?
  for (pptr = hptr->h_aliases; *pptr != NULL; pptr++) {
    //printf("    alias: %s\n", *pptr);
  }
  pptr = hptr->h_addr_list;   // Assumes address type is AF_INET
  for ( ; *pptr != NULL; pptr++) {
    strcpy( IPAddress,  inet_ntop(hptr->h_addrtype, 
				  *pptr, str, sizeof(str)));
    //printf("\taddress: %s\n", IPAddress );
    
    // For each of the IP addresses, find the host address
    if ( (hptr = gethostbyaddr(*pptr, hptr->h_length,
			       hptr->h_addrtype)) == NULL)
      printf("\t(gethostbyaddr failed)\n");
    else if (hptr->h_name != NULL)
      /*printf("\tname = %s\n", hptr->h_name)*/;
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
  
  
  
  char username_send_buffer[BUFFER_SIZE];
  char key_receive_buffer[BUFFER_SIZE];
  char encrypted_password_send_buffer[BUFFER_SIZE];

  /********Send in username ********/
  //zero out the buffer
  bzero(username_send_buffer, sizeof(username_send_buffer));
  
  //store message in output buffer
  sprintf(username_send_buffer, "%s", USERNAME);
  
  //write to socket
  if (write(fd, username_send_buffer, strlen(username_send_buffer)) <= 0) {
    printf("Error in sending username!");
    exit(1);
  } 
  /*else{
	printf("username sent\n");
  }*/
  
  /********Receive unique random number********/
  //zero out the buffer
  bzero(key_receive_buffer, sizeof(key_receive_buffer));
  
  hash_bytes_read = recv(fd, key_receive_buffer, sizeof(key_receive_buffer) - 2, 0);    
  
  if(hash_bytes_read == -1){
    printf("\nError in receiving hash!\n");
    exit(1);
  }
  /*else{
    printf( "%s", key_receive_buffer );
    }*/
  
  /********Encrypt password using number as key********/
  //zero out the buffer
  bzero(encrypted_password_send_buffer, sizeof(encrypted_password_send_buffer));
  //printf("\nKey %s\n", key_receive_buffer);
  strcpy(encrypted_password_send_buffer, crypt(PASSWORD, key_receive_buffer));
  
  //printf("here %s \n", encrypted_password_send_buffer);
  
  /********Send in encrypted value********/
  //write to socket
  if (write(fd, encrypted_password_send_buffer, strlen(encrypted_password_send_buffer)) <= 0) {
    printf("Error in sending encrypted value!");
    exit(1);
  } 
  /*else{
    printf("encrypted value sent\n");
    }*/
  
  //client assumes authentication passed
  
  
  /********Send command********/
  //zero out the output buffer
  bzero(ip_output_buffer, sizeof(ip_output_buffer));
  
  //store message in output buffer
  sprintf(ip_output_buffer, "%s", command);
  
  //write to socket
  if (write(fd, ip_output_buffer, strlen(ip_output_buffer)) <= 0) {
    printf("Error in the write call!\n");
    exit(1);
  }
  
  /********Receive output********/
  //zero out the input buffer
  bzero(ip_input_buffer, sizeof(ip_input_buffer));
  
  while(1){
    //read from socket
    bytes_read = recv(fd, ip_input_buffer, sizeof(ip_input_buffer) - 2, 0);    
    
    if(bytes_read == -1){
      //printf("\nError in the recv call!\n");
      exit(1);
    }
    else if(bytes_read == 0){
      //printf("\nServer closed the connection.\n");
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

void usage(){
  fprintf(stderr, "distributed shell client\n");
  fprintf(stderr, "usage: dsh [flags] <command>, where flags are:\n");
  fprintf(stderr, "\t{-c command}\tcommand to execute remotely\n");
  fprintf(stderr, "\t{-s host}\thost server is on\n");
  fprintf(stderr, "\t[-p #]\t\tport server is on (default is %d)\n", DEFAULT_PORT);
  fprintf(stderr, "\t[-h]\t\tthis help message\n");
  exit(1);
}
