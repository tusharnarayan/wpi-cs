/* 
 * Mark Claypool, WPI
 * Fall 2011, Spring 2014
 * 
 * listen.tcp.c - Illustrate simple TCP connection
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main(int argc, char *argv[]) {
   char message[1024];
   int bytes;
   int sock, serv_host_port, clilen, newsock;
   struct sockaddr_in cli_addr, serv_addr;

   if (argc != 2) {
      fprintf(stderr, "%s - server to accept TCP connections\n", argv[0]);
      fprintf(stderr, "usage: %s <port>\n", argv[0]);
      fprintf(stderr, "\t<port>\t- port to listen on\n");
      exit(1);
   } 

   serv_host_port = atoi(argv[1]);

   printf("Listen activating.\n");

   printf("Trying to create socket at port %d...\n", serv_host_port);   

   /* create socket from which to read */
   if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
      perror("creating socket");
      exit(1);
   }
   
   /* bind our local address so client can connect to us */
   bzero((char *) &serv_addr, sizeof(serv_addr));
   serv_addr.sin_family = AF_INET;
   serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
   serv_addr.sin_port = htons(serv_host_port);
   if (bind(sock, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) {
      perror("can't bind to local address");
      exit(1);
   }

   /* mark socket as passive, with backlog num */
   if (listen(sock, 5) == -1) {
     perror("listen");
     exit(1);
   }

   printf("Socket ready to go! Accepting connections....\n\n");

   /* wait here (block) for connection */
   clilen = sizeof(cli_addr);
   newsock = accept(sock, (struct sockaddr *) &cli_addr, &clilen);
   if (newsock < 0) {
     perror("accepting connection");
     exit(1);
   }
   
   /* read data until no more */
   while ((bytes = read(newsock, message, 1024)) > 0) {
     message[bytes] = '\0'; /* do this just so we can print as string */
     printf("received: '%s'\n", message);
   }

   if (bytes == -1)
     perror("error in read");
   else
     printf("server exiting\n");

   /* close connected socket and original socket */
   close(newsock);
   close(sock);
}
