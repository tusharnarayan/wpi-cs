/*
 * listener.h
 * Tushar Narayan
 * File for project 3
 * header file for listener.c and mcast.c
 * contains common constants, library includes, and a function prototype
 */


#include "msock.h"
#include <sys/wait.h>
#include <fcntl.h>

#define ADDRESS_FOR_QUERY "239.141.188.1"
#define ADDRESS_FOR_REPLY "239.141.188.2"
#define PORT_FOR_QUERY 23000
#define PORT_FOR_REPLY 23001
#define ASCII_DELIMITER "|"

/* function prototype: listener()
 * listen on query port for movie requests
 * stream if found to user
 */
int listener(void);
