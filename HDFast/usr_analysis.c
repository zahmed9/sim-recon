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

void prgeom(FILE* fl);
void usr_dump(void);
int usr_lgd(void);


/******************************
 * Debugging
 *
 * Debug = 0  no debug (default)
 *       = 1  charged tracking
 *       = 3  bcal (mcfast calorimeter)
 *       = 5  lgd (not done by mcfast)
 *       = 7  device hits
 *       = 8  dump Geo 
 *       = 9  hepevt list
 ******************************/

void usr_analysis_(void){

  int i;
  static int nread=0,nsmeared=0,count=0,foundAllGammas;
  static int traced=3;
  int list_trk[TRK_GEN_MAX];
  extern int SaveBrokenEvents,SaveOldFormat,Debug;

  foundAllGammas=0;
  Nread++;
  /* 
   * Make list for offline tracking 
   */
  for(i=0;i<trk_gen_c_.trk_gen_num;i++){
    list_trk[i]= trk_gen_c_.trk_gen[i].hep;
    if(Debug==9)
      fprintf(stderr,"part# %d  q: %f status %d pdgtype %d stbtype %d hepIndex %d \n", i,trk_gen_c_.trk_gen[i].q,trk_gen_c_.trk_gen[i].status,trk_gen_c_.trk_gen[i].pdgtype,trk_gen_c_.trk_gen[i].stbtype,trk_gen_c_.trk_gen[i].hep);
  }

  /*
   * Dump Geo
   */
  if(Debug==8){ /* Dump Geo once */
    prgeom(stdout);
    Debug=0;
  }

  /*
   * Now track them
   */
  
  fctl_offline_(&(trk_gen_c_.trk_gen_num), list_trk);
 
  /*
   * Find ldg gammas
   */
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
	      "\thepIndex: %d type: %d local(x,y): (%lf,%lf) (px,py,pz): (%lf,%lf,%lf)\n\t\t(vx,vy,vz): (%lf,%lf,%lf)\n",
	      LgdParts->part[i].hepIndex,
	      LgdParts->part[i].type,
	      LgdParts->part[i].xlocal,
	      LgdParts->part[i].ylocal,
	      LgdParts->part[i].px,
	      LgdParts->part[i].py,
	      LgdParts->part[i].pz,
	      LgdParts->part[i].vx,
	      LgdParts->part[i].vy,
	      LgdParts->part[i].vz);
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

  if(trk_off1_.trk_off_num ==  trk_gen_c_.trk_gen_num && foundAllGammas
     /* for Ke3 studies -> "&& trk_gen_c_.trk_gen_num>3" */){
    Nsmeared++;

    /*
     *  Save MCFast data in a ROOT Data Tree (rdt file)
     */
    
    if(SaveOldFormat){
      /*
       * Use old file format
       */
      /* fprintf(stderr,"Saving %d particles\n",trk_off1_.trk_off_num);*/
      usr_fill_event(trk_off1_.trk_off_num);/* for chrg. part. only */
      usr_mcfio_out_();
    }else
      usr_dump();
    free(LgdParts);
  }else{
    /* 
     * Save the broken events to the old stdhep "evt file" format
     */
    if(SaveBrokenEvents)
      usr_mcfio_out_(); 
  }
   
}
