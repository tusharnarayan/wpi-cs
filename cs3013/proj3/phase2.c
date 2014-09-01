#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <time.h>

pthread_mutex_t intersection;
pthread_mutex_t turnNL; //coming from North, going left
pthread_mutex_t turnNS; //coming from North, going straight
pthread_mutex_t turnNR; //coming from North, going right
pthread_mutex_t turnWL; //coming from West, going left
pthread_mutex_t turnWS; //coming from West, going straight
pthread_mutex_t turnWR; //coming from West, going right
pthread_mutex_t turnEL; //coming from East, going left
pthread_mutex_t turnES; //coming from East, going straight
pthread_mutex_t turnER; //coming from East, going right
pthread_mutex_t turnSL; //coming from South, going left
pthread_mutex_t turnSS; //coming from South, going straight
pthread_mutex_t turnSR; //coming from South, going right

typedef struct Car Car;

struct Car{
  //pthread_mutex_t inline_mutex;
  Car* infront;
  Car* inback;
};

Car* frontN = (Car *) NULL;
Car* frontE = (Car *) NULL;
Car* frontS = (Car *) NULL;
Car* frontW = (Car *) NULL;
Car* backN = (Car *) NULL;
Car* backE = (Car *) NULL;
Car* backS = (Car *) NULL;
Car* backW = (Car *) NULL;

int rand_turn(){
  /*direction car wants to go in:
   *1 - Left
   *2 - Straight
   *3 - Right
   */
  return (random()%3 + 1);
}

int rand_dir(){
  /*direction car is coming from:
   *1 - North
   *2 - East
   *3 - South
   *4 - West
   */
  return (random()%4 + 1);
}

//returns the mutex that the particular car needs to wait on
//based on the car's approach direction and destination
pthread_mutex_t mutexes_required(int dir, int turn){
  if(dir == 1){
    // Coming from North
    if(turn == 1)
      return turnNL;
    else if(turn == 2)
      return turnNS;
    else
      return turnNR;
  } 
  else if(dir == 2){
    // Coming from East
    if(turn == 1)
      return turnEL;
    else if(turn == 2)
      return turnES;
    else
      return turnER;
  }
  else if(dir == 3){
    // Coming from South
    if(turn == 1)
      return turnSL;
    else if(turn == 2)
      return turnSS;
    else
      return turnSR;
  }
  else{
    // Coming from West
    if(turn == 1)
      return turnWL;
    else if(turn == 2)
      return turnWS;
    else
      return turnWR;
  }
}

//Car function
void *Car_Function(void* ptr){
  pthread_mutex_t my_turn;
  pthread_mutex_t my_spot;
  pthread_mutex_init(&my_spot, NULL);
  int* arg = (int *) ptr;
  int my_turn_num = *arg;
  arg++;
  int my_dir_num = *arg;
  arg++;
  int my_car_num = *arg;
  my_turn = mutexes_required(my_turn_num, my_dir_num);
  Car my_car;

  if(my_dir_num == 1){ //if dir == North
    my_car.infront = backN;
    my_car.inback = (Car *) NULL;
    backN = &my_car;
  }
  else if(my_dir_num == 2){ //if dir == East
    my_car.infront = backE;
    my_car.inback = (Car *) NULL;
    backE = &my_car;
  }
  else if(my_dir_num == 3){ //if dir == South
    my_car.infront = backS;
    my_car.inback = (Car *) NULL;
    backS = &my_car;
  }
  else { //if dir == West
    my_car.infront = backW;
    my_car.inback = (Car *) NULL;
    backW = &my_car;
  }
 
  if(my_car.infront != (Car *) NULL){
    pthread_mutex_lock(&my_spot);
  }
  //done with the Queue part
 
  pthread_mutex_lock(&my_turn);
  pthread_mutex_lock(&intersection);
  if(my_dir_num == 1){ //if dir == North
    if(my_car.inback != (Car *) NULL) frontN = my_car.inback;
    else backN = (Car *) NULL;
  }
  else if(my_dir_num == 2){ //if dir == East
    if(my_car.inback != (Car *) NULL) frontE = my_car.inback;
    else backE = (Car *) NULL;
  }
  else if(my_dir_num == 3){ //if dir == South
    if(my_car.inback != (Car *) NULL) frontS = my_car.inback;
    else backS = (Car *) NULL;
  }
  else { //if dir == West
    if(my_car.inback != (Car *) NULL) frontW = my_car.inback;
    else backW = (Car *) NULL;
  }
 

  if(my_dir_num == 1){
    if(my_turn_num == 1){
      pthread_mutex_lock(&turnSS);
      pthread_mutex_lock(&turnSR);
      pthread_mutex_lock(&turnSL);
      pthread_mutex_lock(&turnWS);
      pthread_mutex_lock(&turnWR);
      pthread_mutex_lock(&turnWL);
      pthread_mutex_lock(&turnES);
      pthread_mutex_lock(&turnEL);
    }
    else if(my_turn_num == 2){
      pthread_mutex_lock(&turnSL);
      pthread_mutex_lock(&turnWS);
      pthread_mutex_lock(&turnWR);
      pthread_mutex_lock(&turnWL);
      pthread_mutex_lock(&turnES);
      pthread_mutex_lock(&turnEL);
    }
    else{
      pthread_mutex_lock(&turnSL);
      pthread_mutex_lock(&turnES);
      pthread_mutex_lock(&turnEL);
    }
  }
  else if(my_dir_num == 2){
    if(my_turn_num == 1){
      pthread_mutex_lock(&turnSS);
      pthread_mutex_lock(&turnSL);
      pthread_mutex_lock(&turnWS);
      pthread_mutex_lock(&turnWR);
      pthread_mutex_lock(&turnWL);
      pthread_mutex_lock(&turnNS);
      pthread_mutex_lock(&turnNR);
      pthread_mutex_lock(&turnNL);
    }
    else if(my_turn_num == 2){
      pthread_mutex_lock(&turnSS);
      pthread_mutex_lock(&turnSL);
      pthread_mutex_lock(&turnWL);
      pthread_mutex_lock(&turnNS);
      pthread_mutex_lock(&turnNR);
      pthread_mutex_lock(&turnNL);
    }
    else{
      pthread_mutex_lock(&turnSL);
      pthread_mutex_lock(&turnSS);
      pthread_mutex_lock(&turnWL);
    }
  }
  else if(my_dir_num == 3){
    if(my_turn_num == 1){
      pthread_mutex_lock(&turnES);
      pthread_mutex_lock(&turnEL);
      pthread_mutex_lock(&turnER);
      pthread_mutex_lock(&turnWS);
      pthread_mutex_lock(&turnWL);
      pthread_mutex_lock(&turnNS);
      pthread_mutex_lock(&turnNR);
      pthread_mutex_lock(&turnNL);
    }
    else if(my_turn_num == 2){
      pthread_mutex_lock(&turnES);
      pthread_mutex_lock(&turnEL);
      pthread_mutex_lock(&turnER);
      pthread_mutex_lock(&turnWS);
      pthread_mutex_lock(&turnWL);
      pthread_mutex_lock(&turnNL);
    }
    else{
      pthread_mutex_lock(&turnWL);
      pthread_mutex_lock(&turnWS);
      pthread_mutex_lock(&turnNL);
    }
  }
  else{
    if(my_turn_num == 1){
      pthread_mutex_lock(&turnES);
      pthread_mutex_lock(&turnEL);
      pthread_mutex_lock(&turnER);
      pthread_mutex_lock(&turnSS);
      pthread_mutex_lock(&turnSL);
      pthread_mutex_lock(&turnSR);
      pthread_mutex_lock(&turnNS);
      pthread_mutex_lock(&turnNL);
    }
    else if(my_turn_num == 2){
      pthread_mutex_lock(&turnSS);
      pthread_mutex_lock(&turnSL);
      pthread_mutex_lock(&turnSR);
      pthread_mutex_lock(&turnEL);
      pthread_mutex_lock(&turnNL);
      pthread_mutex_lock(&turnNS);
    }
    else{
      pthread_mutex_lock(&turnEL);
      pthread_mutex_lock(&turnNS);
      pthread_mutex_lock(&turnNL);
    }
  }
  pthread_mutex_unlock(&intersection);
  printf("\nCar Number %d turning xx way from xx direction is in intersection.\n", my_car_num);
  pthread_mutex_lock(&intersection);
  pthread_mutex_unlock(&my_turn);

  if(my_dir_num == 1){
    if(my_turn_num == 1){
      pthread_mutex_unlock(&turnSS);
      pthread_mutex_unlock(&turnSR);
      pthread_mutex_unlock(&turnSL);
      pthread_mutex_unlock(&turnWS);
      pthread_mutex_unlock(&turnWR);
      pthread_mutex_unlock(&turnWL);
      pthread_mutex_unlock(&turnES);
      pthread_mutex_unlock(&turnEL);
    }
    else if(my_turn_num == 2){
      pthread_mutex_unlock(&turnSL);
      pthread_mutex_unlock(&turnWS);
      pthread_mutex_unlock(&turnWR);
      pthread_mutex_unlock(&turnWL);
      pthread_mutex_unlock(&turnES);
      pthread_mutex_unlock(&turnEL);
    }
    else{
      pthread_mutex_unlock(&turnSL);
      pthread_mutex_unlock(&turnES);
      pthread_mutex_unlock(&turnEL);
    }
  }
  else if(my_dir_num == 2){
    if(my_turn_num == 1){
      pthread_mutex_unlock(&turnSS);
      pthread_mutex_unlock(&turnSL);
      pthread_mutex_unlock(&turnWS);
      pthread_mutex_unlock(&turnWR);
      pthread_mutex_unlock(&turnWL);
      pthread_mutex_unlock(&turnNS);
      pthread_mutex_unlock(&turnNR);
      pthread_mutex_unlock(&turnNL);
    }
    else if(my_turn_num == 2){
      pthread_mutex_unlock(&turnSS);
      pthread_mutex_unlock(&turnSL);
      pthread_mutex_unlock(&turnWL);
      pthread_mutex_unlock(&turnNS);
      pthread_mutex_unlock(&turnNR);
      pthread_mutex_unlock(&turnNL);
    }
    else{
      pthread_mutex_unlock(&turnSL);
      pthread_mutex_unlock(&turnSS);
      pthread_mutex_unlock(&turnWL);
    }
  }
  else if(my_dir_num == 3){
    if(my_turn_num == 1){
      pthread_mutex_unlock(&turnES);
      pthread_mutex_unlock(&turnEL);
      pthread_mutex_unlock(&turnER);
      pthread_mutex_unlock(&turnWS);
      pthread_mutex_unlock(&turnWL);
      pthread_mutex_unlock(&turnNS);
      pthread_mutex_unlock(&turnNR);
      pthread_mutex_unlock(&turnNL);
    }
    else if(my_turn_num == 2){
      pthread_mutex_unlock(&turnES);
      pthread_mutex_unlock(&turnEL);
      pthread_mutex_unlock(&turnER);
      pthread_mutex_unlock(&turnWS);
      pthread_mutex_unlock(&turnWL);
      pthread_mutex_unlock(&turnNL);
    }
    else{
      pthread_mutex_unlock(&turnWL);
      pthread_mutex_unlock(&turnWS);
      pthread_mutex_unlock(&turnNL);
    }
  }
  else{
    if(my_turn_num == 1){
      pthread_mutex_unlock(&turnES);
      pthread_mutex_unlock(&turnEL);
      pthread_mutex_unlock(&turnER);
      pthread_mutex_unlock(&turnSS);
      pthread_mutex_unlock(&turnSL);
      pthread_mutex_unlock(&turnSR);
      pthread_mutex_unlock(&turnNS);
      pthread_mutex_unlock(&turnNL);
    }
    else if(my_turn_num == 2){
      pthread_mutex_unlock(&turnSS);
      pthread_mutex_unlock(&turnSL);
      pthread_mutex_unlock(&turnSR);
      pthread_mutex_unlock(&turnEL);
      pthread_mutex_unlock(&turnNL);
      pthread_mutex_unlock(&turnNS);
    }
    else{
      pthread_mutex_unlock(&turnEL);
      pthread_mutex_unlock(&turnNS);
      pthread_mutex_unlock(&turnNL);
    }
  }

  pthread_mutex_unlock(&intersection);
  printf("\nCar Number %d has exited the intersection.\n", my_car_num);
}

int main (){
  // const pthread_mutexattr_t A;
  srand(time(NULL)); //seeding the time generator
  pthread_mutex_init(&intersection, NULL);
  pthread_mutex_init(&turnNL, NULL);
  pthread_mutex_init(&turnNS, NULL);
  pthread_mutex_init(&turnNR, NULL);
  pthread_mutex_init(&turnWL, NULL);
  pthread_mutex_init(&turnWS, NULL);
  pthread_mutex_init(&turnWR, NULL);
  pthread_mutex_init(&turnEL, NULL);
  pthread_mutex_init(&turnES, NULL);
  pthread_mutex_init(&turnER, NULL);
  pthread_mutex_init(&turnSL, NULL);
  pthread_mutex_init(&turnSS, NULL);
  pthread_mutex_init(&turnSR, NULL);
  pthread_t Car_1, Car_2, Car_3, Car_4, Car_5, Car_6;
  pthread_t Car_7, Car_8, Car_9, Car_10, Car_11;
  pthread_t Car_12, Car_13, Car_14, Car_15, Car_16;
  pthread_t Car_17, Car_18, Car_19, Car_20;
  int C1arg[3];
  C1arg[0] = rand_turn();
  C1arg[1] = rand_dir();
  C1arg[2] = 1;
  int C2arg[3];
  C2arg[0] = rand_turn();
  C2arg[1] = rand_dir();
  C2arg[2] = 2;
  int C3arg[3];
  C3arg[0] = rand_turn();
  C3arg[1] = rand_dir();
  C3arg[2] = 3;
  int C4arg[3];
  C4arg[0] = rand_turn();
  C4arg[1] = rand_dir();
  C4arg[2] = 4;
  int C5arg[3];
  C5arg[0] = rand_turn();
  C5arg[1] = rand_dir();
  C5arg[2] = 5;
  int C6arg[3];
  C6arg[0] = rand_turn();
  C6arg[1] = rand_dir();
  C6arg[2] = 6;
  int C7arg[3];
  C7arg[0] = rand_turn();
  C7arg[1] = rand_dir();
  C7arg[2] = 7;
  int C8arg[3];
  C8arg[0] = rand_turn();
  C8arg[1] = rand_dir();
  C8arg[2] = 8;
  int C9arg[3];
  C9arg[0] = rand_turn();
  C9arg[1] = rand_dir();
  C9arg[2] = 9;
  int C10arg[3];
  C10arg[0] = rand_turn();
  C10arg[1] = rand_dir();
  C10arg[2] = 10;
  int C11arg[3];
  C11arg[0] = rand_turn();
  C11arg[1] = rand_dir();
  C11arg[2] = 11;
  int C12arg[3];
  C12arg[0] = rand_turn();
  C12arg[1] = rand_dir();
  C12arg[2] = 12;
  int C13arg[3];
  C13arg[0] = rand_turn();
  C13arg[1] = rand_dir();
  C13arg[2] = 13;
  int C14arg[3];
  C14arg[0] = rand_turn();
  C14arg[1] = rand_dir();
  C14arg[2] = 14;
  int C15arg[3];
  C15arg[0] = rand_turn();
  C15arg[1] = rand_dir();
  C15arg[2] = 15;
  int C16arg[3];
  C16arg[0] = rand_turn();
  C16arg[1] = rand_dir();
  C16arg[2] = 16;
  int C17arg[3];
  C17arg[0] = rand_turn();
  C17arg[1] = rand_dir();
  C17arg[2] = 17;
  int C18arg[3];
  C18arg[0] = rand_turn();
  C18arg[1] = rand_dir();
  C18arg[2] = 18;
  int C19arg[3];
  C19arg[0] = rand_turn();
  C19arg[1] = rand_dir();
  C19arg[2] = 19;
  int C20arg[3];
  C20arg[0] = rand_turn();
  C20arg[1] = rand_dir();
  C20arg[2] = 20;
  int Car1, Car2, Car3, Car4, Car5, Car6;
  int Car7, Car8, Car9, Car10, Car11, Car12;
  int Car13, Car14, Car15, Car16, Car17, Car18;
  int Car19, Car20;
  
  //fill up void Arrays
  Car1 = pthread_create(&Car_1, NULL, Car_Function,(void *) &C1arg);
  Car2 = pthread_create(&Car_2, NULL, Car_Function,(void *) &C2arg);
  Car3 = pthread_create(&Car_3, NULL, Car_Function,(void *) &C3arg);
  Car4 = pthread_create(&Car_4, NULL, Car_Function,(void *) &C4arg);
  Car5 = pthread_create(&Car_5, NULL, Car_Function,(void *) &C5arg);
  Car6 = pthread_create(&Car_6, NULL, Car_Function,(void *) &C6arg);
  Car7 = pthread_create(&Car_7, NULL, Car_Function,(void *) &C7arg);
  Car8 = pthread_create(&Car_8, NULL, Car_Function,(void *) &C8arg);
  Car9 = pthread_create(&Car_9, NULL, Car_Function,(void *) &C9arg);
  Car10 = pthread_create(&Car_10, NULL, Car_Function,(void *) &C10arg);
  Car11 = pthread_create(&Car_11, NULL, Car_Function,(void *) &C11arg);
  Car12 = pthread_create(&Car_12, NULL, Car_Function,(void *) &C12arg);
  Car13 = pthread_create(&Car_13, NULL, Car_Function,(void *) &C13arg);
  Car14 = pthread_create(&Car_14, NULL, Car_Function,(void *) &C14arg);
  Car15 = pthread_create(&Car_15, NULL, Car_Function,(void *) &C15arg);
  Car16 = pthread_create(&Car_16, NULL, Car_Function,(void *) &C16arg);
  Car17 = pthread_create(&Car_17, NULL, Car_Function,(void *) &C17arg);
  Car18 = pthread_create(&Car_18, NULL, Car_Function,(void *) &C18arg);
  Car19 = pthread_create(&Car_19, NULL, Car_Function,(void *) &C19arg);
  Car20 = pthread_create(&Car_20, NULL, Car_Function,(void *) &C20arg);
  //  printf("\n%d\n", rand_turn());
  pthread_join(Car_1, NULL);
  pthread_join(Car_2, NULL);
  pthread_join(Car_3, NULL);
  pthread_join(Car_4, NULL);
  pthread_join(Car_5, NULL);
  pthread_join(Car_6, NULL);
  pthread_join(Car_7, NULL);
  pthread_join(Car_8, NULL);
  pthread_join(Car_9, NULL);
  pthread_join(Car_10, NULL);
  pthread_join(Car_11, NULL);
  pthread_join(Car_12, NULL);
  pthread_join(Car_13, NULL);
  pthread_join(Car_14, NULL);
  pthread_join(Car_15, NULL);
  pthread_join(Car_16, NULL);
  pthread_join(Car_17, NULL);
  pthread_join(Car_18, NULL);
  pthread_join(Car_19, NULL);
  pthread_join(Car_20, NULL);
  return 0;
}
