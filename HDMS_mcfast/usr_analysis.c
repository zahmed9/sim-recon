/************************************************
 * usr_analysis.c 
 * This function provides the user analysis routines
 * which is  called from mcfast.  This replaces usr_analysis.F  
 *
 * Paul Eugenio
 * Carnegie Mellon University
 * 30 Sept 98
 **********************************************/

#include<stdio.h>
#include <stdlib.h>
#include<gen_track.h>
#include<offline_track.h>

/* 
 * Global used in usr_summary.c
 */
int Nread=0,Nsmeared=0;

void usr_analysis_(void){

  int i;
  static int nread=0,nsmeared=0;
  int list_trk[TRK_GEN_MAX];

  Nread++;
  /* 
   * Make list for offline tracking 
   */
  for(i=0;i<trk_gen_c_.trk_gen_num;i++)
    list_trk[i]= trk_gen_c_.trk_gen[i].hep;
  /*
   * Now track them
   */
  trk_offline_(&(trk_gen_c_.trk_gen_num), list_trk);

  /* 
   * Only save events where all particles are found
   */
  /*  fprintf(stderr,"trk_off_num: %d  trk_gen_num: %d\n",
	  trk_off1_.trk_off_num,trk_gen_c_.trk_gen_num);
   */
  if(trk_off1_.trk_off_num ==  trk_gen_c_.trk_gen_num ){
    Nsmeared++;
    usr_fill_event(trk_off1_.trk_off_num);
    usr_mcfio_out_();
  }
}
