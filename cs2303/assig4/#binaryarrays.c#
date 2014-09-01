/** 
 * Program for writing to and reading from binary files.
 * @author Tushar Narayan
 * tnarayan@wpi.edu
 */

#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h> //for write function
#include <fcntl.h> //for flags in open function
#include <sys/types.h>
#include <sys/stat.h>


#define MAX_LENGTH (20) //max length for employee/dept name

/** 
 * struct _BinEmp
 * Structure for Employees.
 */
struct _BinEmp {
  int salary;
  char name[MAX_LENGTH]; 
  char dept[MAX_LENGTH]; 
};

typedef struct _BinEmp BinEmp; //for convenience

/** Function outputEmployeeToBinary
 * outputs the members of an Employee struct to a binary file
 * with a fixed number of bytes for each employee
 * @param fdesc file descriptor of file to write to
 * @param emp pointer to the employee to write
 * @param num_bytes number of bytes to attempt to write
 * @return void
 */
void outputEmployeeToBinary(int fdesc, BinEmp *emp, int num_bytes) {
  int nw = 0; //num of bytes written, currently none
  nw = write(fdesc, emp, num_bytes);
  if(nw <= 0) fprintf(stderr, 
		      "\nWhoops! Error %d while writing to Binary: %s!\n",
		      errno, strerror(errno));
}

/** main function
 * @return 0 for success, 1 indicating file not opened, 
 * 2 indicated file not closed properly, 3 indicating file not read properly
 */
int main(){
  int fdesc; //file descriptor
  fdesc = open ("binaryarrays.bin", O_WRONLY | O_CREAT, 0644);
  //return immediately if file not opened properly
  if(fdesc < 0){
    printf("\nWhoops! File could not be opened!\nExiting!\n");
    return 1;
  }

  int i; //loop counter

  printf("\nCreating Binary Employees...\n");

  //declaring employees of type BinEmp
  BinEmp new_bin_emp;
  new_bin_emp.salary = 4000;
  memcpy(new_bin_emp.name, "Harry Potter", 13);
  for(i = 13; i <= MAX_LENGTH; i++)
    new_bin_emp.name[i] = '\0';
  memcpy(new_bin_emp.dept, "MOM", 4);
  for(i = 4; i <= MAX_LENGTH; i++)
    new_bin_emp.dept[i] = '\0';
 

  BinEmp bharry;
  bharry.salary = 5000;
  memcpy(bharry.name, "Harry Palmer", 13);
  for(i = 13; i <= MAX_LENGTH; i++)
    bharry.name[i] = '\0';
  memcpy(bharry.dept, "MI6", 4);
  for(i = 4; i <= MAX_LENGTH; i++)
    bharry.dept[i] = '\0';
  
  BinEmp bbluejay;
  bbluejay.salary = 10000;
  memcpy(bbluejay.name, "Erik Grantby", 13);
  for(i = 13; i <= MAX_LENGTH; i++)
    bbluejay.name[i] = '\0';
  memcpy(bbluejay.dept, "KGB", 4);
  for(i = 4; i <= MAX_LENGTH; i++)
    bbluejay.dept[i] = '\0';

  printf("\nOutputting the binary employees to file binaryarrays.bin.\n");

  //Output the employees to the binary file
  outputEmployeeToBinary(fdesc, &new_bin_emp, sizeof(BinEmp));
  outputEmployeeToBinary(fdesc, &bharry, sizeof(BinEmp));
  outputEmployeeToBinary(fdesc, &bbluejay, sizeof(BinEmp));

  int check; //flag to check proper closure of file

  //closing the file after writing to it
  check = close(fdesc);
  if(check == 0) printf("\nData written, file closed successfully!\n");
  else { //return if file not closed properly, after warning user
    printf("Data written, error while closing file.\n");
    return 2;
  }

  // now reading from the file
  printf("\nNow reading the data from file and storing in an array.\n");
  fdesc = open ("binaryarrays.bin", O_RDONLY);

  //return immediately if file not opened properly
  if(fdesc < 0){
    printf("\nWhoops! File could not be opened for reading!\nExiting!\n");
    return 1;
  }

  BinEmp bemps[3]; //array to store BinEmps that are read
  i = 0; // to loop through the bemps array
  BinEmp binemp; //temporary variable to store read data

  int size_bf; //variable to store of the binary file
  struct stat buffer;
  int temp_num = stat("binaryarrays.bin", &buffer);
  size_bf = buffer.st_size;
  int bytes = size_bf;

  while(bytes != 0){
    check = read(fdesc, &binemp, sizeof(BinEmp));

    //return if file not read properly
    if(check < 0){
      printf("\nFile could not be read!\n");
      return 3;
    }
    printf("%s\n%s\n%d", binemp.name, binemp.dept, binemp.salary);
    bemps[i].salary = binemp.salary;
    memcpy(bemps[i].name, binemp.name, 13);
    memcpy(bemps[i].dept, binemp.dept, 4);
    bytes = bytes - sizeof(BinEmp);
    i++;
  }

  //Now printing the array

  printf("\nRead all Employees from binary file. Now printing them...\n");
  for(i = 0; i < 3; i++){
    printf("\nEmployee Number %d:\n", i + 1);
    printf("\tName:\t%s\n", bemps[i].name);
    printf("\tDepartment:\t%s\n", bemps[i].dept);
    printf("\tSalary:\t%d\n", bemps[i].salary);
  }

  printf("\nDone printing. Closing the file now.\n");

  //closing the file after printing
  check = close(fdesc);
  if(check == 0) printf("\nFile closed successfully!\n");
  else { //return if file not closed properly, after warning user
    printf("Error while closing file!\n");
    return 2;
  }

  printf("\nBye!\n\n");

  return 0;
}
