/************************************************
 * usr_summary.c 
 * This function is call at the end of mcfast job
 *
 * Paul Eugenio
 * Carnegie Mellon University
 * 2 Oct 98
 **********************************************/

#include<stdio.h>
#include <stdlib.h>

void usr_summary_(void)
{
  extern int Nread,Nsmeared;

  /*
   * Print the acceptance.
   */
  fprintf(stderr,"\nNumber of mc events read: %d  Number accepted smeared events out: %d (%3.1f%%)\n\n",
	  Nread,Nsmeared,100.0*((double)(Nsmeared)/((double)(Nread))));
	  

}


