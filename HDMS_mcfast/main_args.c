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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void printCoptions(void){

  fprintf(stderr,"MCFast options for the C code:\n\t");
  fprintf(stderr,"-c <file>  file to save raw data (default mcfast.cat)\n");
}
void main_fortran_(int *, char *, int);

char Outfile_HallD[50]="mcfast.cat";
void main(int argc, char *argv[]) {

  int i, j, len, minstring, nstring, size;
  char **string_fortran;
  char *point;
  char blank = ' ';
  char *argptr;
  extern char Outfile_HallD[50];

  /* halld args */
  for (i=1; i<argc; i++) {
    argptr = argv[i];
    if ((*argptr == '-') && (strlen(argptr) > 1)) {
      argptr++;
      switch (*argptr) {
      case 'c':
	argptr++;
	strcpy(Outfile_HallD,++argptr );
	break;
      case 'h':
	printCoptions();
	break;
      default:
      }
    }
  }

  /* end halld args */

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
