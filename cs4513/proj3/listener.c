/*
 * listener.c
 * Tushar Narayan
 * file for project 3
 * contains the listener function definition, along with helper functions
 * A few helper functions were adapted from Project 2: server.c
 * 
 * The file mcast.c from http://web.cs.wpi.edu/~cs4513/d14/samples/mcast.tar
 * (folder: mcast/mcast/mcast.c) was very helpful - pieces of it were adapted for
 * this code.
 */

#include "listener.h"
#include <sys/ioctl.h>
#include <net/if.h>

/* constants for setting up connection */
#define PORT_TO_CONNECT_ON "9010"
#define IP_LEN 16 //length of an ip address (v4)

/* constants for nutella system */
#define LIST_OF_MOVIES	50 //num movies allowed in directory
#define LOCATION_OF_MOVIE_LIST	"./.nutella" //assume movie files are in same folder

/* constants for movie play */
#define MOVIE_MAX_LINES 300
#define MOVIE_MAX_FILENAME_LENGTH 100
#define ACCEPT_WAIT 300000 //wait to avoid resource unavailable error

/* prototypes */
int searchForInputMovieName(char *query_buffer, char list_of_movies[LIST_OF_MOVIES][80], int number_of_movies_discovered);
int getIPAddress(char addr[IP_LEN]);
int openAndBindStream(int port);
int listenAndConnect(int socket);
int playMovie(int socket, char *theFile);

/* function definition: listener()
 * listen on query port for movie requests
 * stream if found to user
 */
int listener(){
  int query_socket_id, reply_socket_id, tcp_socket_id, stream_socket_id, bytesRecv, flag_for_replay, incorrect_response_counter;
  int number_of_movies_discovered = 0;
  char query_buffer[80];
  char ip_of_stream[IP_LEN];
  char response_buffer[120];
  char list_of_movies[LIST_OF_MOVIES][80];
  char handshake_buffer[80];
  char handshake_reponse_buffer[120];
  FILE *movie_fd;
  fd_set readFrom;
  struct timeval timeout, timeout_replay;
  
  timeout.tv_sec = 5;
  timeout.tv_usec = 0;
  timeout_replay.tv_sec = 10;
  timeout_replay.tv_usec = 0;
  
  if ((movie_fd = fopen(LOCATION_OF_MOVIE_LIST, "r")) == NULL){
    perror("error: opening movie file");
    exit(2);
  }
  else{
    while (number_of_movies_discovered < LIST_OF_MOVIES 
	   && (fgets(list_of_movies[number_of_movies_discovered], 80 + 1, movie_fd)) != NULL){
      list_of_movies[number_of_movies_discovered][strlen(list_of_movies[number_of_movies_discovered]) - 1] = '\0';
      number_of_movies_discovered++;
    }
    if (fclose(movie_fd)){
      perror("error: closing file");
      exit(2);
    }
  }
  
  if (getIPAddress(ip_of_stream) < 0){
    perror("error: getting IP address");
    exit(2);
  }
  
  /* open query socket */
  if ((query_socket_id = msockcreate(RECV, ADDRESS_FOR_QUERY, PORT_FOR_QUERY)) < 0){
    perror("error: query_buffer socket creation");
    exit(2);
  }
  /* open response socket */
  if ((reply_socket_id = msockcreate(SEND, ADDRESS_FOR_REPLY, PORT_FOR_REPLY)) < 0){
    perror("error: response socket creation");
    exit(2);
  }
  /* open TCP socket */
  if ((tcp_socket_id = openAndBindStream(atoi(PORT_TO_CONNECT_ON))) < 0){
    perror("error: streaming socket creation");
    exit(2);
  }
  /* set socket to nonblocking so it can time out*/
  if (fcntl(tcp_socket_id, F_SETFL, O_NONBLOCK) < 0){
    perror("error: set nonblocking");
    exit(2);
  }
  
  while(1){
    if (mrecv(query_socket_id, query_buffer, 80 + 1) < 0){
      perror("error: receiving query");
      exit(2);
    }
    
    /* search movie array to see if queried name exists */
    if (searchForInputMovieName(query_buffer, list_of_movies, number_of_movies_discovered) == 0){
      /* movie found, send ip and port information */
      strncpy(response_buffer, query_buffer, strlen(query_buffer) + 1);
      strcat(response_buffer, ASCII_DELIMITER);
      strcat(response_buffer, ip_of_stream);
      strcat(response_buffer, ASCII_DELIMITER);
      strcat(response_buffer, PORT_TO_CONNECT_ON);
      
      sleep(1); //give client time to setup recieve port
      
      /* send response message */
      if (msend(reply_socket_id, response_buffer, strlen(response_buffer) + 1) < 0){
	perror("error: sending response_buffer");
	exit(2);
      }
      
      /* add TCP socket to readset */
      FD_ZERO(&readFrom);
      if (FD_SET(tcp_socket_id, &readFrom) < 0){
	perror("error: could not add tcp_socket_id to readset");
	exit(2);
      }
      
      //code from http://web.cs.wpi.edu/~cs4513/d14/samples/select.c was adapted
      //for the select function
      bytesRecv = select(tcp_socket_id + 1, &readFrom, NULL, NULL, &timeout);
      if (bytesRecv != 0){
	if (FD_ISSET(tcp_socket_id, &readFrom)){
	  if ((stream_socket_id = listenAndConnect(tcp_socket_id)) < 0){
	    perror("error: listening for response");
	    exit(2);
	  }
	  else{
	    do{
	      flag_for_replay = 0;
	      //start streaming movie
	      if (playMovie(stream_socket_id, query_buffer) < 0){
		perror("error: playing movie");
		exit(2);
	      }
	      
	      /* send half of a handshake */
	      if (sprintf(handshake_buffer, "%d", stream_socket_id) < 0){
		perror("error: convert stream sock to handshake");
		exit(2);
	      }
	      usleep(ACCEPT_WAIT); //wait for accept
	      if (write(stream_socket_id, handshake_buffer, 80) == -1){
		perror("error: failed to write");
		exit(2);
	      }
	      incorrect_response_counter = 0;
	      do{
		FD_ZERO(&readFrom);
		if (FD_SET(stream_socket_id, &readFrom) < 0){
		  perror("error: adding tcp_socket_id to readset");
		  exit(2);
		}
		//code from http://web.cs.wpi.edu/~cs4513/d14/samples/select.c was adapted
		//for the select function
		bytesRecv = select(stream_socket_id + 1, &readFrom, NULL, NULL, &timeout_replay);
		if (bytesRecv > 0){
		  if (FD_ISSET(stream_socket_id, &readFrom)){
		    if (read(stream_socket_id, handshake_reponse_buffer, 120) < 0){
		      perror("error: receiving handshake response");
		      exit(2);
		    }
		    /* look for handshake_buffer for each reply */
		    if (strncmp(handshake_buffer, handshake_reponse_buffer, strlen(handshake_buffer) + 1) == 0){
		      flag_for_replay++;
		      break;
		    }
		    else{
		      //incorrect response
		      incorrect_response_counter++;
		    }
		  }
		}
		else if (bytesRecv == 0){
		  break;
		}
	      } while ((bytesRecv != 0) || (incorrect_response_counter < 10));
	    } while (flag_for_replay > 0);
	    if (close(stream_socket_id) < 0){
	      perror("error: closing stream socket");
	      exit(2);
	    }
	  }
	}
      }
    }	
  }
  /* close the query socket */
  if (msockdestroy(query_socket_id) < 0){
    perror("error: query_buffer socket destruction");
    exit(2);
  }
  
  /* close the response socket */
  if (msockdestroy(reply_socket_id) < 0){
    perror("error: response socket destruction");
    exit(2);
  }
  
  /* close the TCP socket*/
  if (close(tcp_socket_id) < 0){
    perror("error: closing tcp socket");
    exit(2);
  }	
  return 0;
}

/*
 * searchForInputMovieName()
 * iterate over movie list array, return 0 if match found, else return 1
 */
int searchForInputMovieName(char *query_buffer, char list_of_movies[LIST_OF_MOVIES][80], int number_of_movies_discovered){
  int i;
  for (i = 0; i < number_of_movies_discovered; i++){
    if (strncmp(query_buffer, list_of_movies[i], strlen(query_buffer)) == 0){
      return 0;
    }
  }
  return 1;
}

/*
 * getIPAddress()
 * returns 0 on success
 * returns -1 if error
 * IP stored in addr parameter
 */
int getIPAddress(char addr[IP_LEN]){
  int sock;
  int ret = 0;
  struct ifreq ifr;
  
  if ((sock = socket(AF_INET, SOCK_DGRAM, 0)) < 0){ //open a dummy socket to test
    perror("error: open socket");
    ret = EXIT_FAILURE;
  }
  else{
    strcpy(ifr.ifr_name, "eth0"); //wired connection on ccc
    if (ioctl(sock, SIOCGIFADDR, &ifr) < 0){
      strcpy(addr, "0.0.0.0");
      perror("error: reading ip");
      ret = EXIT_FAILURE;
    }
    sprintf(addr, "%s", inet_ntoa(((struct sockaddr_in *) &(ifr.ifr_addr))->sin_addr));
    close(sock); //close dummy socket
  }
  return ret;
}

/*
 * openAndBindStream()
 * opens a TCP stream and binds it with the given port.
 * return socket id on success or -1 on error
 * code adapted from Project2: server.c
 */
int openAndBindStream(int port){
  int listening_socket;
  struct sockaddr_in server_address;
  
  listening_socket = socket(AF_INET, SOCK_STREAM, 0);
  if (listening_socket == -1){
    perror("error: creating socket");
  }
  else{
    bzero((char *) &server_address, sizeof(server_address));
    server_address.sin_family = AF_INET;
    server_address.sin_addr.s_addr = htonl(INADDR_ANY);
    server_address.sin_port = htons(port);
    if ((bind(listening_socket, (struct sockaddr *) &server_address, sizeof(server_address))) < 0)
      {
	perror("error: can't bind to local address");
	close(listening_socket);
	listening_socket = -1;
      }
  }
  return listening_socket;
}

/*
 * listenAndConnect()
 * 
 * return socket id if successful
 * returns 0 if timed out
 * return -1 if error
 * code adapted from project2: server.c
 */
int listenAndConnect(int listening_socket){
  int active_conn_socket = 0;
  int client_address_size;
  struct sockaddr_in client_address;
  
  client_address_size = sizeof(client_address);	
  listen(listening_socket, 5);
  usleep(ACCEPT_WAIT); //wait for accept to catch up
  if ((active_conn_socket = accept(listening_socket, (struct sockaddr *) &client_address, &client_address_size)) < 0){
    perror("error: accept");
    active_conn_socket = -1;
  }
  return active_conn_socket;
}

/*
 * playMovie()
 *
 * return 0 on success, else return -1
 * some code adapted from Project 2: server.c
 */
int playMovie(int socket_to_play_to, char *fileToPlay_name){
  int endOfFrame_flag, endOfFile_flag, return_value;
  char frame_to_display[100000];
  char temp_frame_buffer[MOVIE_MAX_LINES];
  
  char fileToPlay_start[] = "./";
  char fileToPlay_extension[] = ".txt";
  char fileToPlay[MOVIE_MAX_FILENAME_LENGTH];
  FILE *movie_fd;
  
  return_value = 0;
  
  strcpy(fileToPlay, fileToPlay_start);
  strcat(fileToPlay, fileToPlay_name);
  strcat(fileToPlay, fileToPlay_extension);
  
  if ((movie_fd = fopen(fileToPlay, "r")) == NULL){
    perror("error: opening file");
    return_value = -1;
  }
  else{
    endOfFile_flag = 0;
    while (endOfFile_flag == 0){
      frame_to_display[0] = '\0';
      endOfFrame_flag = 0;
      while (endOfFrame_flag == 0){
	if (fgets(temp_frame_buffer, MOVIE_MAX_LINES + 1, movie_fd) == (char *) NULL){
	  /* if end of file, set endOfFile_flag */
	  endOfFile_flag++;
	}
	else{
	  /* if "end" encountered set a flag */
	  if (strncmp(temp_frame_buffer, "end", 3) == 0){
	    endOfFrame_flag++;
	  }
	  else{
	    /* add to frame */
	    strncat(frame_to_display, temp_frame_buffer, strlen(temp_frame_buffer));
	  }
	}
	if (endOfFile_flag > 0) break;
      }
      /* send frame */
      if (endOfFile_flag == 0){
	/* pause for appropriate frame rate - sleep for 100000ms */
	usleep(100000);
	/* write to stdout */
	if (write(socket_to_play_to, frame_to_display, strlen(frame_to_display) + 1) == -1){
	  perror("error: failed to write");
	  return_value = -1;
	}
      }
    }
    if (write(socket_to_play_to, "end", 3) == -1){
      perror("error: failed to write end");
      return_value = -1;
    }
    if (fclose(movie_fd)){
      perror("error: closing file");
      return_value = -1;
    }
  }
  return return_value;
}
