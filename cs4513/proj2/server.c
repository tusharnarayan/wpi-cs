//Tushar Narayan
//tnarayan@wpi.edu
#define _XOPEN_SOURCE


#include <unistd.h>
#include <semaphore.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <time.h>
#include <strings.h>

#define BUFFER_SIZE 1024
#define DEFAULT_PORT 7778
#define DEFAULT_DIR "/home/tnarayan/cs4513/proj2"

#define USERNAME "john"
#define PASSWORD "test_password"

void usage();

int main(int argc, char *argv[]){
  int port_number;
  char *dir;
  
  int c;
  int pflag = 0, dflag = 0;
  extern int optind, opterr;
  extern char *optarg;
  
  char input_buffer[BUFFER_SIZE];  //input buffer to hold the message from the client
  
  pid_t cpid;
  int status;
  static int counter = 0; //count number of connections
  int experiment_test = 0;
  
  //variables for sockets for client and server
  unsigned int listening_socket;
  unsigned int active_conn_socket;
  
  //variables for storing socket addresses for client and server
  struct sockaddr_in server_address;
  struct sockaddr_in client_address;
  
  srand(time(NULL));
  
  socklen_t client_address_size = sizeof(client_address);
  
  while((c = getopt (argc, argv, "hp:d:e")) != EOF){
    switch(c){
    case 'p':
      port_number = atoi(optarg);
      pflag++;
      break;
    case 'd':
      dir = optarg;
      dflag++;
      break;
    case 'h':
      usage();
    case 'e':
      experiment_test = 1;
    }
  }
  
  printf("./server activating.\n");
  
  if(pflag == 0){
    //printf("Using default port of %d\n", DEFAULT_PORT);
    port_number = DEFAULT_PORT;
  }

  if(dflag == 0){
    //printf("Using default dir of %s\n", DEFAULT_DIR);
    dir = DEFAULT_DIR;
  }
  else{
    if(chdir(dir) == -1){
      printf("Error changing working directory to %s\n", dir);
      perror("error");
      exit(12);
    }
  }
  
  printf("\tport: %d\n", port_number);
  printf("\tdir: %s\n", dir);
  
  
  //create new server socket
  listening_socket = socket(AF_INET, SOCK_STREAM, 0);
  if(listening_socket == -1){
    printf("Error creating the socket!\n");
    exit(2);
  }
  
  //fill in the server_address variable that is of type sockaddr_in
  server_address.sin_family = AF_INET; //matching the socket() call for family
  
  server_address.sin_port = htons(port_number); //specify the port that server will listen on
  server_address.sin_addr.s_addr = htonl(INADDR_ANY); //bind to *any* local address
  
  //Note: used htons() and htonl() because Networks are Big Endian
  //but hosts can be either Big or Little Endian
  
  //bind the server socket
  int bind_outcome =  bind(listening_socket, (struct sockaddr *) &server_address, sizeof(server_address));
  
  if(bind_outcome == -1){
    printf("Error binding the socket for the server!\n");
    exit(2);
  }
  
  printf("Socket created! Accepting connections.\n");
  
  //listen for client connections
  int listen_outcome = listen(listening_socket, 50);
  //this sets the maximum number of pending connections to the server to 50
  
  if(listen_outcome == -1){
    printf("Error listening for handshake!\n");
    exit(2);
  }
  //printf("The server is ready and listening on port %d.\n", port_number);
  
  
  for(;;){
    printf("\n\n");
    if((active_conn_socket = accept(listening_socket, (struct sockaddr *) &client_address, &client_address_size)) == -1){
      perror("accept");
      exit(10);
    }
    printf("Connection request received.\n");
    cpid = fork();
    if(cpid < 0){
      printf("Fork failed. Please try running again. %s\n", strerror(errno));
      close(active_conn_socket);
      exit(11);
    }
    if(cpid != 0){
      close(active_conn_socket);
      counter++;
      //sleep(5);
      if(waitpid(cpid, &status, 0) != cpid) fprintf(stderr, "waitpid failed\n");
      //fprintf(stderr, "Child process done. I am the parent.\n");
    }
    else{
      fprintf(stderr, "forked child\n");
	 
      char username_receive_buffer[BUFFER_SIZE];
      char key_send_buffer[BUFFER_SIZE];
      char encrypted_password_receive_buffer[BUFFER_SIZE];
      char encrypted_password_check_buffer[BUFFER_SIZE];
      
      /********Receive username ********/
      bzero(username_receive_buffer, sizeof(username_receive_buffer));
      
      int received_username_size = recv(active_conn_socket, username_receive_buffer, BUFFER_SIZE - 1, 0);
      
      if(received_username_size < 0){
	perror("receiving username");
      }else{
	username_receive_buffer[BUFFER_SIZE] = '\0';
	printf("received:%s\n", username_receive_buffer);
      }
      
      /********Send out unique random number********/
      int random_number = rand();
      
      bzero(key_send_buffer, sizeof(key_send_buffer));
      
      sprintf(key_send_buffer, "%d", random_number);
      
      if (write(active_conn_socket, key_send_buffer, strlen(key_send_buffer)) <= 0) {
	printf("Error in sending key!");
	exit(1);
      }
      /*else{
	printf("key sent\n");
	}*/
      
      /********Receive encrypted value********/
      bzero(encrypted_password_receive_buffer, sizeof(encrypted_password_receive_buffer));
      
      int received_encrypted_password_size = recv(active_conn_socket, encrypted_password_receive_buffer, BUFFER_SIZE - 1, 0);
      
      if(received_encrypted_password_size < 0){
	perror("receiving encrypted password");
      }else{
	//printf("encrypted value received\n");
	encrypted_password_receive_buffer[BUFFER_SIZE] = '\0';
      }
      
      /********Encrypt password using number as key********/
      bzero(encrypted_password_check_buffer, sizeof(encrypted_password_check_buffer));
      bzero(key_send_buffer, sizeof(key_send_buffer));
      
      sprintf(key_send_buffer, "%d", random_number);
      //printf("\nKey %s\n", key_send_buffer);
      
      strcpy(encrypted_password_check_buffer, crypt(PASSWORD, key_send_buffer));
      
      
      /********Compare two encrypted values********/
      int check_value = strcmp(encrypted_password_check_buffer, encrypted_password_receive_buffer);
      if(check_value == 0){
	printf("password ok\n");
      }
      else{
	printf("Could not authenticate\n");

      dup2(active_conn_socket, STDOUT_FILENO);  /* duplicate socket on stdout */
      dup2(active_conn_socket, STDERR_FILENO);  /* duplicate socket on stderr too */
      printf("User could not be authenticated, exiting...\n");
      close(active_conn_socket);  /* can close the original after it's duplicated */

	//printf("encrypted_password_check_buffer is %s\n", encrypted_password_check_buffer);
	//printf("encrypted_password_receive_buffer is %s\n", encrypted_password_receive_buffer);
      exit(30);
      }
      
      /********Receive command********/
      memset(&input_buffer, '\0', sizeof(char)*BUFFER_SIZE);
      int received_message_size = recv(active_conn_socket, input_buffer, BUFFER_SIZE - 1, 0);
      if(received_message_size < 0){
	perror("recv");
      }else{
	input_buffer[BUFFER_SIZE] = '\0';
      }
      
      /********Parse command********/
      char *argmnts[64];
      int i = 0;
      printf("command: ");      
      char *temp = strtok(input_buffer, " ");
      while(temp != NULL){
	if(temp[0] == '\0') break;
	argmnts[i] = temp;
	printf("%s\n", argmnts[i]);
	i++;
	temp = strtok(NULL, " ");
	if(temp == NULL) break;
      }
      
      argmnts[i] = NULL;
      
      /********Execute command********/
      if(experiment_test == 0){
	printf("executing command...\n");
      
	dup2(active_conn_socket, STDOUT_FILENO);  /* duplicate socket on stdout */
	dup2(active_conn_socket, STDERR_FILENO);  /* duplicate socket on stderr too */
      
	int returnnum = execvp(argmnts[0], argmnts);
	printf("returnvalue is %d: %s\n", returnnum, strerror(errno));
      }
      else{
	printf("No exec call because of -e flag.\n");
      }
      close(active_conn_socket);  /* can close the original after it's duplicated */
    }
  }
  
  close(listening_socket);
  return 0; //return 0 on success   
} //End of main

void usage(){
  fprintf(stderr, "distributed shell server\n");
  fprintf(stderr, "usage: server [flags], where flags are:\n");
  fprintf(stderr, "\t-p #\t\tport server is on (default is %d)\n", DEFAULT_PORT);
  fprintf(stderr, "\t-d dir\tdirectory to serve out of (default is %s)\n", DEFAULT_DIR);
  fprintf(stderr, "\t-h\t\tthis help message\n");
  exit(1);
}
