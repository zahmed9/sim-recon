/************************************************
 * usr_init.c 
 * This routine is called from mcfast to
 * perform initializations .
 * Paul Eugenio
 * Carnegie Mellon University
 * 28 Sept 98
 **********************************************/

#include<stdio.h>
#include <stdlib.h>

void usr_init_(void)
{
  int nChan=100,iD=10;
  float xMin=-0.05,xMax=0.05,zero=0.0;

  fprintf(stderr,"Trying to hbook\n");

  hbook1_(&iD,"Delta Px",&nChan,&xMin,&xMax,&zero,8);
  fprintf(stderr,"Booking histogram id: %d\n",iD++);
 
  hbook1_(&iD,"Delta Py",&nChan,&xMin,&xMax,&zero,8);
  fprintf(stderr,"Booking histogram id: %d\n",iD++);
  
  hbook1_(&iD,"Delta Pz",&nChan,&xMin,&xMax,&zero,8);
  fprintf(stderr,"Booking histogram id: %d\n",iD++);
 
  hbook1_(&iD,"Delta E",&nChan,&xMin,&xMax,&zero,8);
  fprintf(stderr,"Booking histogram id: %d\n",iD++);

  hcdir_("//PAWC"," ",6,1);

}
