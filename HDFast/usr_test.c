/************************************************
 * usr_test.c 
 * 
 * Test the mcfast code
 *
 * Paul Eugenio 
 * Carnegie Mellon University
 * 
 **********************************************/

#include<stdio.h>
#include <stdlib.h>
#include<gen_track.h>
#include<offline_track.h>
#include<usr_lgd.h>
#include<stdhep_alloc.h>

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
  static int nread=0,count=0,foundAllGammas;
  int list_trk[TRK_GEN_MAX];

  Nread++;

  /* 
   * Make list for offline tracking 
   */
  for(i=0;i<trk_gen_c_.trk_gen_num;i++){
    list_trk[i]= trk_gen_c_.trk_gen[i].hep;
    
    fprintf(stderr,
	    "part# %d  q: %f status %d pdgtype %d stbtype %d hepIndex %d \n", 
	    i,trk_gen_c_.trk_gen[i].q,trk_gen_c_.trk_gen[i].status,
	    trk_gen_c_.trk_gen[i].pdgtype,trk_gen_c_.trk_gen[i].stbtype,
	    trk_gen_c_.trk_gen[i].hep);
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
  fprintf(stderr,"trk_off_num: %d  trk_gen_num: %d\n",
	  trk_off1_.trk_off_num,trk_gen_c_.trk_gen_num);

  /* 
   * Only look at events where all tracks were found.
   */
  if( trk_off1_.trk_off_num ==  trk_gen_c_.trk_gen_num) {
    Nsmeared++;
    
    /*
     * dump offline track info
     */
    for(i=0;i< trk_off1_.trk_off_num;i++)
      fprintf(stderr,"i= %d 
trk_off2_.trk_off[i].hep =%d
hepevt_.idhep[trk_off2_.trk_off[i].hep -1] = %d
hepevt_.isthep[trk_off2_.trk_off[i].hep -1]= %d
trk_off2_.trk_off[i].mass = %f
trk_off2_.trk_off[i].w.px = %f
trk_off2_.trk_off[i].w.py = %f
trk_off2_.trk_off[i].w.pz = %f
trk_off2_.trk_off[i].w.e = %f\n",i,trk_off2_.trk_off[i].hep  ,
	      hepevt_.idhep[trk_off2_.trk_off[i].hep -1 ],
	      hepevt_.isthep[trk_off2_.trk_off[i].hep -1],
	      trk_off2_.trk_off[i].mass,
	      trk_off2_.trk_off[i].w.px,
	      trk_off2_.trk_off[i].w.py,
	      trk_off2_.trk_off[i].w.pz,
	      trk_off2_.trk_off[i].w.e );
  }
  fprintf(stderr,"\n");
   
}
