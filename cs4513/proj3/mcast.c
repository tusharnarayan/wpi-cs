/* mcast.c
 * Tushar Narayan
 * File for project3
 * Nutella client process
 *
 */

#include "listener.h"

//function prototype
int setupStreamingSocketConnection(char *address_of_host, int port_to_connect_on);

//main function for Nutella client
int main(void){
  pid_t listener_process_id;
  int query_socket_id, reply_socket_id, stream_socket_id, bytes_read, child_process_id, received_bytes, found_movie;
  int incorrect_reply_counter, flag_for_replay;
  char name_of_movie[80];
  char replay_buffer[80];
  char response_buffer[120];
  char frame_buffer[100000];
  char *part_of_response;
  char *ip_of_stream;
  char handshake_buffer[80];
  int port_to_connect_on;
  int flag_for_exit = 0;
  fd_set readFrom;
  struct timeval timeout;
  
  timeout.tv_sec = 5;
  timeout.tv_usec = 0;
  
  /* fork and start listener */
  if ((listener_process_id = fork()) < 0){
    perror("error: fork failed");
    exit(3);
  }
  else if (listener_process_id == 0){ //child process
    listener();
  }
  else{ //parent process
    if ((query_socket_id = msockcreate(SEND, ADDRESS_FOR_QUERY, PORT_FOR_QUERY)) < 0){
      perror("error: query socket creation");
      exit(3);
    }
    if ((reply_socket_id = msockcreate(RECV, ADDRESS_FOR_REPLY, PORT_FOR_REPLY)) < 0){
      perror("error: receive socket creation");
      exit(3);
    }
    
    /* set socket to nonblocking so it can time out*/
    if (fcntl(reply_socket_id, F_SETFL, O_NONBLOCK) < 0){
      perror("error: setting non-blocking");
      exit(3);
    }
    
    /* start the Query loop */
    while (flag_for_exit == 0){	
      received_bytes = 0;			
      printf("Type in the movie you would like to see: \n");
      scanf("%s", name_of_movie);
      
      /* if it's the exit command, set the exit flag and break */
      if (strncmp(name_of_movie, "exit", strlen("exit")) == 0){
	flag_for_exit++;
	break;
      }
      
      /* send request for movie name */
      if (msend(query_socket_id, name_of_movie, strlen(name_of_movie) + 1) < 0){
	perror("error: sending query");
	exit(3);
      }
      
      /* listen for reply */
      /* add the receive socket to the readset */
      FD_ZERO(&readFrom);
      if (FD_SET(reply_socket_id, &readFrom) < 0){
	perror("error: adding reply_socket_id to readset");
	exit(3);
      }
      found_movie = 0;
      incorrect_reply_counter = 0;
      do{
	//code from http://web.cs.wpi.edu/~cs4513/d14/samples/select.c was adapted
	//for the select function
	received_bytes = select(reply_socket_id + 1, &readFrom, NULL, NULL, &timeout);
	if (received_bytes == 0){ //if select returns 0 it timed out
	  printf("The movie \"%s\" cannot be found at this time. Please try again.\n", name_of_movie);
	  break;
	}
	if (FD_ISSET(reply_socket_id, &readFrom)){
	  if (mrecv(reply_socket_id, response_buffer, 120 + 1) < 0){
	    perror("error: receiving response");
	    exit(3);
	  }
	  
	  /* check that the right reply was received */
	  part_of_response = strtok(response_buffer, ASCII_DELIMITER);
	  if ((strncmp(name_of_movie, part_of_response, strlen(name_of_movie) + 1)) == 0){
	    found_movie++;
	    /* parse required information */
	    ip_of_stream = strtok(NULL, ASCII_DELIMITER);
	    port_to_connect_on = atoi(strtok(NULL, ASCII_DELIMITER));
	    
	    /* send tcp request for movie on parsed ip and port */
	    if ((stream_socket_id = setupStreamingSocketConnection(ip_of_stream, port_to_connect_on)) < 0){
	      perror("error: connecting to stream");
	      exit(3);
	    }
	    /* start player loop until end of file */
	    do{
	      flag_for_replay = 0; // reset flag
	      while ((bytes_read = read(stream_socket_id, frame_buffer, 100000)) > 0){
		//clear screen code from http://web.cs.wpi.edu/~cs4513/d14/samples/clear.c
		printf("\033[2J");
		printf("\033[0;0f");
		//end clear screen code
		
		//display frame
		if (strncmp(frame_buffer, "end", 3) != 0){
		  printf("%s", frame_buffer);
		}
		else{
		  break;
		}
	      }
	      /* receive from server half of a handshake */
	      if ((bytes_read = read(stream_socket_id, handshake_buffer, 80)) < 0){
		perror("error: receiving handshake");
		exit(3);
	      }
	      printf("replay_buffer? y/n\n");
	      scanf("%s", replay_buffer);
	      /*
	       * if response starts with 'y', respond with handshake
	       */
	      if (strncmp(replay_buffer, "y", 1) == 0){
		flag_for_replay++; // return to the start of the loop
		/* send response */
		if (write(stream_socket_id, handshake_buffer, strlen(handshake_buffer) + 1) < 0){
		  perror("error: replying with handshake");
		  exit(3);
		}
	      }
	    } while (flag_for_replay > 0);
	  }
	  else{
	    /* not found, continue looping */
	    incorrect_reply_counter++; //if this gets too high, the loop will end
	  }
	}
      } while ((found_movie == 0) || (incorrect_reply_counter == 100));
    }
    /* close all multicast sockets */
    if (msockdestroy(query_socket_id) < 0){ //close the Query socket
      perror("error: msockdestroy for query");
      exit(3);
    }
    
    if (msockdestroy(reply_socket_id) < 0){ //close the Receive socket
      perror("error: msockdestroy for reply");
      exit(3);
    }
    //kill child process
    killpg(0, SIGKILL);
    wait(&child_process_id);	
  }
  return 0;
}

/*
 * setupStreamingSocketConnection()
 * connects to the given address at the given port
 * returns socket number if successful or -1 on error
 * Adapted from Project 2: dsh.c
 */
int setupStreamingSocketConnection(char *address_of_host, int port_to_connect_on){
  int sock = 0;
  int family = AF_INET;       /* The default for most cases */
  int type   = SOCK_STREAM;   /* Says it's a TCP connection */
  struct sockaddr_in sa;
  struct hostent *hptr;
  
  bzero((void *) &sa, sizeof(sa));
  if ((hptr = gethostbyname(address_of_host)) == NULL){
    perror("error: host name error");
    sock = -1;
  }
  else{
    bcopy(hptr->h_addr, (char *) &sa.sin_addr, hptr->h_length);
    sa.sin_family = family;
    sa.sin_port = htons(port_to_connect_on);
    
    if ((sock = socket(family, type, 0)) < 0){
      perror("error: opening socket");
      sock = -1;
    }
    else{
      if (connect(sock, (struct sockaddr *) &sa, sizeof(sa)) < 0){
	perror("error: can't connect");
	sock = -1;
      }
      else{
	printf("Found, playing movie...\n");
      }
    }
  }
  return sock;
}
