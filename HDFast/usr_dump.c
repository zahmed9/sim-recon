/************************************************
 * usr_dump.c 
 * This routine is called from usr_analysis.c to
 * write out the mcfast common black data to a 
 * C-structure binary file.
 * Paul Eugenio
 * Carnegie Mellon University
 * 9 Nov 98
 **********************************************/

#include<stdio.h>
#include <stdlib.h>
#include<math.h>

#include<stdhep_alloc.h>
#include<stdlun.h>
#include<stdcnt.h>
#include<offline_track.h>
#include<trace.h>
#include<tof.h>
#include<cal_hit.h>
#include<usr_lgd.h>

struct offline_track_struct *trk_off;
struct trace_s *trace,tmp_trace[TRACE_MAX];
struct heppart_t *heppart;

struct ntraces_t {
  int ntraces;      /* Number of track intersections */
  struct trace_s *trace_par;
} ;
struct ntrkoff_t {
  int ntracks;
  struct offline_track_struct *trk_off;
} ;
struct hepevt_t {
  int nevhep;             /* The event number */
  int nhep;               /* The number of entries in this event */
  struct heppart_t *heppart;
};

struct cal_hits_t {
  int nCalHits;
  cal_hit **calhit;
};

struct event_t {
  struct ntraces_t traces;    // defined in TMCFastTOF.h
  struct hepevt_t  mcevt;  // defined in TMCFastHepEvt.h
  struct ntrkoff_t offtrk;  // defined in TMCFastOfflineTrack.h  
  struct cal_hits_t calor0; // defined in TMCFastCalorimeter.h
  lgd_smearedparts_t *lgdSmears;  
  
};


void usr_dump(void){ 
  
  int i,j;
  double rloc,zloc;
   
  int trk_off_num=0;
  int trace_num=0;
  int nevhep,nhep=0;
  extern int Debug,SaveUsingMCFIO;
  struct event_t event;
  extern lgd_smearedparts_t *LgdParts;
  
  /*
   * Allocate memory and copy the hepevt_ common block
   */
  nevhep=hepevt_.nevhep;
  nhep=hepevt_.nhep;
  heppart = malloc(sizeof(struct heppart_t)*nhep);
  
  for(i=0;i<nhep;i++){
    heppart[i].isthep = hepevt_.isthep[i];
    heppart[i].idhep = hepevt_.idhep[i];
    for(j=0;j<2;j++)
      heppart[i].jmohep[j] = hepevt_.jmohep[i][j];
    for(j=0;j<2;j++)
      heppart[i].jdahep[j] = hepevt_.jdahep[i][j];
    for(j=0;j<5;j++)
      heppart[i].phep[j] = hepevt_.phep[i][j];
    for(j=0;j<4;j++)
      heppart[i].vhep[j] = hepevt_.vhep[i][j];
  }

  /*
   * Allocate mem and copy the trk_off1_ common block
   */
  trk_off_num=trk_off1_.trk_off_num;
  trk_off = malloc(sizeof(struct offline_track_struct)*trk_off_num);
		   
  for(i=0;i<trk_off_num;i++)
    trk_off[i] = trk_off2_.trk_off[i];


  /*
   * Allocate mem and copy only the TOF traces
   * from the trace_par_c_ common block
   */


  trace_num=0;
  for(i=0;i<trace_par_c_.trace_num;i++){ /* find the TOF traces */
    if(Debug==2){
      zloc=trace_par_c_.trace_par[i].w.z;
      rloc=sqrt(trace_par_c_.trace_par[i].w.x * 
		trace_par_c_.trace_par[i].w.x +
		trace_par_c_.trace_par[i].w.y * 
		trace_par_c_.trace_par[i].w.y);
      fprintf(stderr,
	"typ: %d plane: %d nhit: %d path: %lf time: %lf tau: %lf loc(r,z): %lf %lf \n",
		trace_par_c_.trace_par[i].type,
		trace_par_c_.trace_par[i].plane,
		trace_par_c_.trace_par[i].hit,
		trace_par_c_.trace_par[i].path,
		trace_par_c_.trace_par[i].time,
	       trace_par_c_.trace_par[i].tau,
		rloc,zloc);
    }/* end of debug */

    if((trace_par_c_.trace_par[i].type ==PRODUCTION && 
       trace_par_c_.trace_par[i].plane == PRODUCTION_PLANE) ||
       (trace_par_c_.trace_par[i].type ==CENTRAL &&
	(int)(trace_par_c_.trace_par[i].w.x * trace_par_c_.trace_par[i].w.x +
	    trace_par_c_.trace_par[i].w.y * trace_par_c_.trace_par[i].w.y +0.1)
        == (int)(CTOF_R*CTOF_R)) ||
       (trace_par_c_.trace_par[i].type ==FORWARD &&
	(int)(trace_par_c_.trace_par[i].w.z) == (int)(FTOF_Z))){
      /* 
       * we have a TOF trace 
       */

      tmp_trace[trace_num] = trace_par_c_.trace_par[i];
      trace_num++;
    
      if(Debug==1){    
	zloc=trace_par_c_.trace_par[i].w.z;
	rloc=sqrt(trace_par_c_.trace_par[i].w.x * 
		  trace_par_c_.trace_par[i].w.x +
		  trace_par_c_.trace_par[i].w.y * 
		  trace_par_c_.trace_par[i].w.y);	
	fprintf(stderr,
	 "typ: %d plane: %d nhit: %d path: %lf time: %lf tau: %lf loc(r,z): %lf %lf \n",
		trace_par_c_.trace_par[i].type,
		trace_par_c_.trace_par[i].plane,
		trace_par_c_.trace_par[i].hit,
		trace_par_c_.trace_par[i].path,
		trace_par_c_.trace_par[i].time,
		trace_par_c_.trace_par[i].tau,
		rloc,zloc);
      }
    }
  }
  /* alocate and copy */
  trace = malloc(sizeof(struct trace_s)*trace_num);
  for(i=0;i<trace_num;i++){
    trace[i]= tmp_trace[i];
    /*
     * Change trace type to 41 for CTOF & 42 for FTOF
     */
    
    if( trace[i].type ==CENTRAL &&
	(int)(trace[i].w.x * trace[i].w.x + trace[i].w.y * trace[i].w.y + 0.1)
	== (int)(CTOF_R*CTOF_R)){
      trace[i].type = 41 /*TMCFAST_CENTRAL_TRACE*/;
    }
    if(trace[i].type ==FORWARD &&
       (int)(trace[i].w.z) == (int)(FTOF_Z))
      trace[i].type = 42 /*TMCFAST_FORWARD_TRACE*/;
  }


  /*
   *  Get the Colorimetry hits
   * Calorimetry Debug=3
   */

  {
    int i,j,ical=0;
    cal_hit *hit;
    cal_hit_tracks *tr;
    
    if(Debug==3){
      for(i=0;i<1;i++)
	fprintf(stderr,"Num_cal_hits(%d)= %d\n",i,num_cal_hits_(i));
      
      for(i=0; i< MCFNumHitCal[ical]; i++) {
	hit = MCFCalHits[ical][i];
	if (hit == NULL){
	  fprintf(stderr," Colorimeter hit has null pointer\n");
	  continue;
	}
	/**************** Now dump cal info ***************/
	fprintf(stderr,
		"coord1 cell#: %d coord2 cell#: %d e_mip: %f  e_em: %f  e_had: %f\n",
		hit->icr1,hit->icr2,hit->e_mip,hit->e_em,hit->e_had);
	fprintf(stderr,"Ntracks: %d status: %d\n",hit->n_tracks,hit->status);
	for (j=0, tr=hit->info_tr; j<hit->n_tracks; j++, tr++) 
	  fprintf(stderr,"\ttrackNum: %d percent_e_tot: %f\n",tr->tr_num,tr->percent_e_tot);
	fprintf(stderr,"\n");
      }
    }
  }




  /*
   * Now set the event pointers.
   */
  event.mcevt.nevhep= nevhep;
  event.mcevt.nhep= nhep;
  event.mcevt.heppart= heppart;

  event.offtrk.ntracks= trk_off_num;
  event.offtrk.trk_off= trk_off;

  event.traces.ntraces= trace_num;
  event.traces.trace_par= trace;
  
  event.calor0.nCalHits =  MCFNumHitCal[0];
  event.calor0.calhit = MCFCalHits[0];

  /*
   * event.calor1.nCalHits = MCFNumHitCal[1];
   * event.calor1.calhit = MCFCalHits[1];  
   */
  event.lgdSmears = LgdParts;


  /*
   * Create C++ objects and save 
   * them to a ROOT Tree.
   */
  usr_mcfast2root(&event);

   /*
    * Free the allocated memory
    */
   free(heppart);
   free(trk_off);
   free(trace);

}

