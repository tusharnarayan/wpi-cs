#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#define NUM_PIRATE 12
#define NUM_NINJA 4
int Ninja = 0;
int Pirate = 0;
sem_t Ninjalock;
sem_t Piratelock;
sem_t Ninjabar;
sem_t Piratebar;
sem_t Ninjas;
sem_t Pirates;
sem_t turnstile;


void *Ninja_Function(void *ptr){
  int IAM;
  int *NJid = (int *)ptr;
  sem_wait (&turnstile);
  sem_wait (&Ninjabar);
  sem_wait (&Ninjalock);
  Ninja ++;
  IAM = Ninja;
  sem_post (&Ninjalock);
  if (IAM == 1){
    sem_wait (&Piratebar);
    printf("\nI am the first Ninja in! %d\n", *NJid);
  }
  sem_post (&Ninjabar);
  sem_post (&turnstile);
  sem_wait (&Ninjas);
  sleep(1);
  printf("\nNinja #%d", *NJid);
  sem_post (&Ninjas);
  sem_wait (&Ninjalock);
  Ninja --;
  sem_post (&Ninjalock);
  if (Ninja == 0){
    sem_post (&Piratebar);
    printf("\nI am the last Ninja out. %d\n", *NJid);
    }
}

void *Pirate_Function(void *ptr){
  int IAM;
  int *PRid = (int *)ptr;
  sem_wait (&turnstile);
  sem_wait (&Piratebar);
  sem_wait (&Piratelock);
  Pirate++;
  IAM = Pirate;
  sem_post (&Piratelock);
  if (IAM ==1){
    sem_wait (&Ninjabar);
    printf("\nI am the first Pirate in! %d, %d\n", *PRid, IAM);
  }
  sem_post (&Piratebar);
  sem_post (&turnstile);
  sem_wait (&Pirates);
  sleep(1);
  printf("\nPirate #%d!", *PRid);
  sem_post (&Pirates);
  Pirate --;
  if (Pirate == 0){
    sem_post (&Ninjabar);
    printf("\nIm the last pirate out! %d\n", *PRid);
  }
}

int main(){
  sem_init (&Ninjas, 0,2);
  sem_init (&Ninjabar, 0,1);
  sem_init (&Piratebar, 0,1);
  sem_init (&Pirates, 0,2);
  sem_init(&turnstile, 0, 1);
  sem_init(&Piratelock, 0, 1);
  sem_init(&Ninjalock, 0,1);
  int P1ret, P2ret,P3ret,P4ret,P5ret,P6ret,P7ret,P8ret,P9ret,P10ret;
  int P11ret,P12ret, N1ret, N2ret, N3ret, N4ret;
  pthread_t Pirate_1, Pirate_2, Pirate_3, Pirate_4, Pirate_5, Pirate_6;
  pthread_t Pirate_7, Pirate_8, Pirate_9, Pirate_10, Pirate_11;
  pthread_t Pirate_12, Ninja_1, Ninja_2, Ninja_3, Ninja_4;
  int P1arg, P2arg, P3arg, P4arg, P5arg, P6arg, P7arg, P8arg, P9arg, P10arg;
  int P11arg, P12arg, N1arg, N2arg, N3arg, N4arg;
  P1arg = 1;
  P2arg = 2;
  P3arg = 3;
  P4arg = 4;
  P5arg = 5;
  P6arg = 6;
  P7arg = 7;
  P8arg = 8;
  P4arg = 4;
  P5arg = 5;
  P6arg = 6;
  P7arg = 7;
  P8arg = 8;
  P9arg = 9;
  P10arg = 10;
  P11arg = 11;
  P12arg = 12;
  N1arg = 1;
  N2arg = 2;
  N3arg = 3;
  N4arg = 4;
  P1ret = pthread_create(&Pirate_1, NULL, Pirate_Function,(void *) &P1arg);
  P2ret = pthread_create(&Pirate_2, NULL, Pirate_Function,(void *) &P2arg);
  P3ret = pthread_create(&Pirate_3, NULL, Pirate_Function,(void *) &P3arg);
  P4ret = pthread_create(&Pirate_4, NULL, Pirate_Function,(void *) &P4arg);
  P5ret = pthread_create(&Pirate_5, NULL, Pirate_Function,(void *) &P5arg);
  P6ret = pthread_create(&Pirate_6, NULL, Pirate_Function,(void *) &P6arg);
  P7ret = pthread_create(&Pirate_7, NULL, Pirate_Function,(void *) &P7arg);
  P8ret = pthread_create(&Pirate_8, NULL, Pirate_Function,(void *) &P8arg);
  P9ret = pthread_create(&Pirate_9, NULL, Pirate_Function,(void *) &P9arg);
  P10ret = pthread_create(&Pirate_10, NULL, Pirate_Function,(void *) &P10arg);
  P11ret = pthread_create(&Pirate_11, NULL, Pirate_Function,(void *) &P11arg);
  P12ret = pthread_create(&Pirate_12, NULL, Pirate_Function,(void *) &P12arg);
  N1ret = pthread_create(&Ninja_1, NULL, Ninja_Function,(void *) &N1arg);
  N2ret = pthread_create(&Ninja_2, NULL, Ninja_Function,(void *) &N2arg);
  N3ret = pthread_create(&Ninja_3, NULL, Ninja_Function,(void *) &N3arg);
  N4ret = pthread_create(&Ninja_4, NULL, Ninja_Function,(void *) &N4arg);

  //need to check if they were ACTUALLY created by checking the return values!

  pthread_join(Pirate_1, NULL);
  pthread_join(Pirate_2, NULL);
  pthread_join(Pirate_3, NULL);
  pthread_join(Pirate_4, NULL);
  pthread_join(Pirate_5, NULL);
  pthread_join(Pirate_6, NULL);
  pthread_join(Pirate_7, NULL);
  pthread_join(Pirate_8, NULL);
  pthread_join(Pirate_9, NULL);
  pthread_join(Pirate_10, NULL);
  pthread_join(Pirate_11, NULL);
  pthread_join(Pirate_12, NULL);
  pthread_join(Ninja_1, NULL);
  pthread_join(Ninja_2, NULL);
  pthread_join(Ninja_3, NULL);
  pthread_join(Ninja_4, NULL);
  printf("\n");
  return 0;
}

