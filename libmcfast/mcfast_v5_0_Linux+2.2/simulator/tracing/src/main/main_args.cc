/*
******************************************************************************
This is a main routine which picks off the command line arguments and
passes them to the Fortran program main_fortran.

This program can handle an indefinite number of strings of arbitrary length.
The Fortran subroutine is written as

   subroutine main_fortran(ncomnds, command)

   integer ncomnds
   character*(*) command(0:ncomnds)

If the user types

    program str1 str2 str3 ... strn

then ncomnds = n and
     command(0) = "program"
     command(1) = "str1"
     command(2) = "str2"
     .
     .
     .
     command(n) = "strn"
******************************************************************************
*/
#include <string.h>

extern "C" void main_fortran_(int *, char *, int);

void main(int argc, char *argv[]) {

  int i, j, len, minstring, nstring, size;
  char **string_fortran;
  char *point;
  char blank = ' ';

/* Find the longest string among the arguments */
  size = 0;
  for (i=0; i < argc; i++) 
    size = (size < strlen(argv[i])) ? strlen(argv[i]) : size;

/* Make sure space is reserved for 1 string if no args */
  size = (size > 0) ? size : 80;
  minstring = (argc > 1) ? argc : 1;
  nstring = argc -1;

/* Allocate space for the string pointers */
  string_fortran = (char **) malloc(minstring*sizeof(char *));

/* Allocate space for the strings (need minstring x size chars) */
  point = (char *) malloc(minstring*size*sizeof(blank));
  for (i=0; i < minstring; i++) string_fortran[i] = point + i*size;

/* Fill the first Fortran string with blanks so that it's defined */
  for (j=0; j < size; j++) string_fortran[0][j] = blank;

/* Loop over strings in argv and convert them into Fortran style strings.
   Be careful to blank fill the strings passed to Fortran */
  for (i=0; i < argc; i++) {
/*    printf("String number %d = %s\n", i, argv[i] ); */
    len = (int) strlen(argv[i]);
    strncpy(string_fortran[i], argv[i], len);
    for (j=len; j < size; j++) string_fortran[i][j] = blank;
  }

/* Pass the info to the fortran routine */
  main_fortran_(&nstring, string_fortran[0], size);
}
