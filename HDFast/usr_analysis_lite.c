/************************************************
 * usr_analysis_lite.c 
 * 
 * This object is used to make HDFast_lite which is
 * a version of HDFast that does not use root output.
 * Because of this, it is only limited to charged particle
 * final states. The output is in "evt" stdhep format and
 * only contains the smeared particle informatin.
 *
 * Paul Eugenio 
 * Carnegie Mellon University
 * 11 Nov 99
 **********************************************/

#include<stdio.h>
#include <stdlib.h>
#include<offline_track.h>

#include<stdhep.h>
#include<gen_track.h>
/* 
 * Global used in usr_summary.c
 */
int Nread=0,Nsmeared=0;
void usr_fill_event(int nparts);

/******************************
 * Debugging
 *
 * Debug = 0  no debug (default)
 *       = 1  charged tracking
 *       = 2  dump Geo 
 ******************************/



void usr_analysis_(void){

  int i;
  static int nread=0,count=0;
  int list_trk[TRK_GEN_MAX];
  extern int  SaveBrokenEvents,Debug;

  Nread++;

  /* 
   * Make list for offline tracking 
   */
  for(i=0;i<trk_gen_c_.trk_gen_num;i++){
    list_trk[i]= trk_gen_c_.trk_gen[i].hep;
    if(Debug==1)
    fprintf(stderr,
	    "part# %d  q: %f status %d pdgtype %d stbtype %d hepIndex %d \n", 
	    i,trk_gen_c_.trk_gen[i].q,trk_gen_c_.trk_gen[i].status,
	    trk_gen_c_.trk_gen[i].pdgtype,trk_gen_c_.trk_gen[i].stbtype,
	    trk_gen_c_.trk_gen[i].hep);
  }

   /*
   * Dump Geo
   */
  if(Debug==2){ /* Dump Geo once */
    prgeom(stdout);
    Debug=0;
  }
 


  /*
   * Now track them
   */
  
  fctl_offline_(&(trk_gen_c_.trk_gen_num), list_trk);
 

  if((count++ -1)%50==0){
    fprintf(stderr,"Read in %d events. %d smeared events were accepted.\n",
	    count-1,Nsmeared);
    fflush(stderr);
  }
   if(Debug==1 )
     fprintf(stderr,"trk_off_num: %d  trk_gen_num: %d\n",
	     trk_off_c_.trk_off_num,trk_gen_c_.trk_gen_num);

  /* 
   * Only look at events where all tracks were found.
   */
  if( trk_off_c_.trk_off_num ==  trk_gen_c_.trk_gen_num) {
    Nsmeared++;
    /*
     * dump offline track into the hepevt structure
     */
    if(!SaveBrokenEvents){
      usr_fill_event(trk_off_c_.trk_off_num);
      usr_mcfio_out_();
    }
  }else{
    if(SaveBrokenEvents) /* Save the generated event */
      usr_mcfio_out_(); 
  }
  
  
   
}
