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
#include<usr_lgd.h>

/* 
 * Global used in usr_summary.c
 */
int Nread=0,Nsmeared=0;
lgd_smearedparts_t *LgdParts;


void usr_dump(void);
int usr_lgd(void);

void usr_analysis_(void){

  int i;
  static int nread=0,nsmeared=0,count=0,foundAllGammas;
  static int traced=3;
  int list_trk[TRK_GEN_MAX];
  extern int SaveUsingMCFIO,Debug;

  foundAllGammas=0;
  Nread++;
  /* 
   * Make list for offline tracking 
   */
  for(i=0;i<trk_gen_c_.trk_gen_num;i++)
    list_trk[i]= trk_gen_c_.trk_gen[i].hep;
  
  /*
   * Now track them
   */
  
  fctl_offline_(&(trk_gen_c_.trk_gen_num), list_trk);
  foundAllGammas=0;
  /*
   * usr_lgd() allocates memory for LgdParts
   * and it must be free'd after calling usr_dump
   */
  foundAllGammas=usr_lgd(); /* remember to free memory */

  if((count++ -1)%50==0){
    fprintf(stderr,"Read in %d events. %d smeared events were accepted.\n",
	    count-1,Nsmeared);
    fflush(stderr);
  }


  if(Debug==5){
    fprintf(stderr,"Found All Gammas? %d\n",foundAllGammas);
    fprintf(stderr,"NlgdGammas: %d\n",LgdParts->nparts);
    for(i=0;i<LgdParts->nparts;i++)
      fprintf(stderr,
	      "\thepIndex: %d type: %d local(x,y): (%lf,%lf) (px,py,pz): (%lf,%lf,%lf)\n",
	      LgdParts->part[i].hepIndex,
	      LgdParts->part[i].type,
	      LgdParts->part[i].xlocal,
	      LgdParts->part[i].ylocal,
	      LgdParts->part[i].px,
	      LgdParts->part[i].py,
	      LgdParts->part[i].pz);
  }
  /* 
    * Only save events where all particles are found
   */
  if(Debug==1)
    fprintf(stderr,"trk_off_num: %d  trk_gen_num: %d\n",
	  trk_off1_.trk_off_num,trk_gen_c_.trk_gen_num);

  /* fprintf(stderr,"Analyzing event: %d\r",count);
   * fflush(stderr);
   */
  if(trk_off1_.trk_off_num ==  trk_gen_c_.trk_gen_num && foundAllGammas){
    Nsmeared++;

    /*
     *  Save HEPEVT, Trace information in bin file
     */
    if(!SaveUsingMCFIO)
      usr_dump();
   
    free(LgdParts);

    /* 
     * Replace the generated events with the smeared events.
     */
    if(SaveUsingMCFIO)
      usr_fill_event(trk_off1_.trk_off_num);

    /* 
     * Save the event using the old stdhep "evt file" format 
     */
    if(SaveUsingMCFIO)
      usr_mcfio_out_(); 
    
   } 
}
