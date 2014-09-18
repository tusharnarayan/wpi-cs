/* 
 * Mark Claypool, WPI
 * Fall 2011, Spring 2014
 *
 * talk.tcp.c - Illustrate simple TCP connection
 * 
 * Calls a server named as the first argument 
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
   char buf[80]; 
   unsigned long int inaddr;
   int sock, serv_host_port;
   struct sockaddr_in serv_addr;
   char *serv_host_addr;
   struct hostent *hp;

   if (argc != 3) {
      fprintf(stderr, "%s - client to try TCP connection to server", argv[0]);
      fprintf(stderr, "usage: %s <host> <port>\n", argv[0]);
      fprintf(stderr, "\t<host>\t- Internet name of server host\n");
      fprintf(stderr, "\t<port>\t- port\n");
      exit(1);
   }
 
   serv_host_addr = argv[1];
   serv_host_port = atoi(argv[2]);
   
   printf("Talk activated.\n\n");
   printf("Trying to connect to server %s at port %d...\n", 
	  serv_host_addr, serv_host_port);

   /* lookup hostname.
    * (Note - gethostbyname() deprecated, could use getaddrinfo())
    */
   bzero((void *) &serv_addr, sizeof(serv_addr));
   printf("Looking up %s...\n", serv_host_addr);
   if ((hp = gethostbyname(serv_host_addr)) == NULL) {
     perror("host name error");
     exit(1);
   }
   bcopy(hp->h_addr, (char *) &serv_addr.sin_addr, hp->h_length);

   printf("Found it.  Setting port connection to %d...\n", serv_host_port);
   serv_addr.sin_family = AF_INET;
   serv_addr.sin_port = htons(serv_host_port);
   /* serv_addr.sin_addr.s_addr = inet_addr(serv_host_addr); */

   /* create a TCP socket (an Internet stream socket). */
   puts("Done. Creating socket...");
   if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
     perror("creating socket");
     exit(1);
   }

   /* socket created, so connect to the server */
   puts("Created. Trying connection to server...");
   if (connect(sock, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) {
     perror("can't connect");
     exit(1);
   }

   printf("Connection established!\n");
   printf("Type in messages to send to server.\n");

   /* read from stdin, sending to server, until quit */
   while (fgets(buf, 80, stdin)) {
     buf[strlen(buf)-1] = '\0'; /* remove last \n */
     printf("sending: '%s'\n", buf);
     if (write(sock, buf, strlen(buf)) == -1) {
       perror("write failed");
       break;
     }
   }

   /* close socket */
   close(sock);
}


   
