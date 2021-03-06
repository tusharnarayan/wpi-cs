//CS3516 B Term, 2013
//Computer Networks
//Project 1
//web server

//Tushar Narayan
//tnarayan@wpi.edu

#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//required for file i/o functions
#include <sys/stat.h>
#include <fcntl.h>

//required for the in_addr_t struct
//in_addr_t is "an unsigned integral type of exactly 32 bits"
#include <arpa/inet.h>

#include <sys/socket.h>
//contains AF_INET: address family to use for the socket
//contains SOCK_STREAM: from http://unixhelp.ed.ac.uk/CGI/man-cgi?socket+2

//required for the bind function
#include <sys/types.h>

#define BUFFER_SIZE 5000

void *work_thread(void *arg); // Prototype

/////////////////////////////////////////////////////////////////////////
//  This is the main() code - it is the original thread
/////////////////////////////////////////////////////////////////////////
int main(int argc, char *argv[]){
  int port_number;
  if(argc != 2){
    printf("usage: %s <port-number>\n", argv[0]);
    exit(1);
  }
  else{
    //assuming that the input is a valid number
    port_number = atoi(argv[1]);
  }
  
  //variables for the child threads so that we can
  //serve more than one request at a time
  pthread_attr_t thread_attributes; //pthread attributes
  pthread_t threads; //thread ids
  unsigned int new_thread_identifier; //thread arguments 
  pthread_attr_init(&thread_attributes); //needed for threads

  //variables for sockets for client and server
  unsigned int server_socket_descriptor;
  unsigned int client_socket_descriptor;

  //variables for storing socket addresses for client and server
  struct sockaddr_in server_address;
  struct sockaddr_in client_address;
  //using sockaddr_in instead of the sockaddr struct because it is 
  //easier to just cast to that instead of forming the parts of the sockaddr
  //using a for loop

  //create new server socket
  //function prototype from man: socket(family, type, protocol)
  //family is the protocol family, use AF_INET for IPv4
  //type is the communication type, use a streaming socket (SOCK_STREAM)
  //protocol set to 0 for default
  //on success, socket() will return the socket descriptor

  server_socket_descriptor = socket(AF_INET, SOCK_STREAM, 0);
  if(server_socket_descriptor == -1){
    printf("Error creating the socket!");
  }

  //fill in the server_address variable that is of type sockaddr_in
  server_address.sin_family = AF_INET; //matching the socket() call for family

  //from the Linux man pages:
  //"The htons() function converts the unsigned short integer hostshort from host byte order to network byte order."
  server_address.sin_port = htons(port_number); //specify the port that server will listen on

  //from the Linux man pages:
  //"The htonl() function converts the unsigned integer hostlong from host byte order to network byte order."
  server_address.sin_addr.s_addr = htonl(INADDR_ANY); //bind to *any* local address

  //Note: used htons() and htonl() because Networks are Big Endian
  //but hosts can be either Big or Little Endian

  //bind the server socket
  //the bind assigns a local address, which is required before the stream 
  //can receive connections
  //function prototype from man: bind(sd, *myaddr, addrlen)
  //sd is the socket descriptor that the socket() function returned to indicate outcome
  //*myaddr is of type sockaddr! need to cast
  //addrlen is the size of the socket address structure
  int bind_outcome =  bind(server_socket_descriptor, (struct sockaddr *) &server_address, sizeof(server_address));

  if(bind_outcome == -1){
    printf("Error binding the socket for the server!");
  }

  //listen for client connections
  //this listens for the handshake from the client
  //function prototype from man: listen(sd, backlog)
  //sd is the socket descriptor for the server
  //backlog max number of connections that should be in the queue of connections for socket
  int listen_outcome = listen(server_socket_descriptor, 50);
  //this sets the maximum number of pending connections to the server to 50

  if(listen_outcome == -1){
    printf("Error listening for handshake!");
  }

  printf("The server is ready and listening on port %d.\n", port_number);

  //once we recieve a connection, we go into a (infinite) loop
  //in the loop, we listen for more connection requests
  //each new connection request leads to a new child thread
  while(1){
    
    //try to accept the connection to the client
    //function prototype from man: accept(sd, *cliaddr, *addrlen)
    //sd is the server's socket descriptor
    //*cliaddr stores the address of the client
    //*addrlen stores the size of cliaddr
    int client_address_size = sizeof(client_address);
    client_socket_descriptor = accept(server_socket_descriptor, (struct sockaddr*) &client_address, &client_address_size);

    if(client_socket_descriptor == -1){
      printf("Error accepting the connection!");
      exit(3);
    }
    else{
      //create a thread, give it the connection to the client
      //thus, the server can service multiple client
      //requests at the same time
      new_thread_identifier = client_socket_descriptor;
      pthread_create(&threads, &thread_attributes, work_thread, &new_thread_identifier);      
    }
  }

  sleep(4);
  close(server_socket_descriptor);
  return 0; //return 0 on success 
} //End of main

/////////////////////////////////////////////////////////////////////////
//  This is the code executed by the new thread 
/////////////////////////////////////////////////////////////////////////
void *work_thread(void *arg){
  unsigned int this_thread_client;

  printf("\n");

  //input buffer to hold the message from the client
  char input_buffer[BUFFER_SIZE];
  //output buffer to hold the response to the client
  char output_buffer[BUFFER_SIZE];

  //zero out the buffers
  memset(&input_buffer, '\0', sizeof(input_buffer));
  memset(&output_buffer, '\0', sizeof(output_buffer));

  char *requested_file;
  unsigned int fh;
  unsigned int fbs;
  unsigned int received_message_size;

  this_thread_client = *(unsigned int *)arg;

  while(received_message_size = recv(this_thread_client, input_buffer, BUFFER_SIZE, 0) > 0){   
    printf("%s\n", input_buffer);
  }
  
  if(received_message_size == -1){
    printf("Error reading message from client!");
  }
  
  pthread_exit(NULL);
}
