/************************************************
 * usr_dump.c 
 * This routine is called from usr_analysis.c to
 * write out the mcfast common black data to a 
 * Root Data Tree (rdt) file.
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
#include<calor_hits.h>
#include<usr_lgd.h>
#include <dev_hit.h>
#include <hit_track.h>

struct offline_track_struct *trk_off;
struct trace_s *trace,tmp_trace[50],tmp2_trace[20];
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
/*
struct cal_hits_t {
  int nCalHits;
  cal_hit **calhit;
};
*/

struct event_t {
  struct ntraces_t traces;    /* defined in TMCFastTOF.h */
  struct ntraces_t ctraces;    /* cerenkov trace points */
  struct hepevt_t  mcevt;  /* defined in TMCFastHepEvt.h */
  struct ntrkoff_t offtrk;  /* defined in TMCFastOfflineTrack.h  */
  struct cal_hits_t calor0; /* defined in TMCFastCalorimeter.h */
  lgd_smearedparts_t *lgdSmears;  
  struct dev_hits_t *devhits; 
  struct dev_hits_t *devhits_cdc;  
};

int usr_hits(int devtype,int devnum,struct dev_hits_t *devhits);
void usr_calor(struct cal_hits_t *Calor);

void usr_dump(void){ 
  
  int i,j;
  double rloc,zloc;
   
  int trk_off_num=0;
  int trace_num=0,trace_num2=0;
  int nevhep,nhep=0;
  extern int Debug,SaveUsingMCFIO;
  struct event_t event;
  extern lgd_smearedparts_t *LgdParts;

  int devtype, devnum;
  struct dev_hits_t devhits;
  struct dev_hits_t devhits_cdc;
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
      heppart[i].vhep[j] = hepevt_.vhep[i][j]/10.0;// HEPEVT uses mm
						   // convert to cm
  }

  /*
   * Allocate mem and copy the trk_off1_ common block
   */
  trk_off_num=trk_off_c_.trk_off_num;
  trk_off = malloc(sizeof(struct offline_track_struct)*trk_off_num);
		   
  for(i=0;i<trk_off_num;i++)
    trk_off[i] = trk_off_c_.trk_off[i];


  /*
   * Allocate mem and copy only the TOF traces
   * from the trace_par_c_ common block
   */
  trace_num=0;
  trace_num2=0;
  for(i=0;i<trace_par_c_.trace_num;i++){
    int haveIt=0;
    /*
     * Kludge fix the hits (they are missing the the trace index)
     */
    /* for consistency use FORTRAN indexology i.e. start w/ 1 */
    /**
     * if(trace_par_c_.trace_par[i].hit != 0)
     * hit_trk_c_.hit_trk[trace_par_c_.trace_par[i].hit - 1].trace = i+1;
     *
     **/
    
    /* find the TOF traces */
   
    if(Debug==2){
      zloc=trace_par_c_.trace_par[i].w.z;
      rloc=sqrt(trace_par_c_.trace_par[i].w.x * 
		trace_par_c_.trace_par[i].w.x +
		trace_par_c_.trace_par[i].w.y * 
		trace_par_c_.trace_par[i].w.y);
      fprintf(stderr,
	"typ: %d plane: %d hit: %d hep: %d path: %lf time: %lf tau: %lf loc(r,z): %lf %lf \n",
	      trace_par_c_.trace_par[i].type,
	      trace_par_c_.trace_par[i].plane,
	      trace_par_c_.trace_par[i].hit,
	      trace_par_c_.trace_par[i].hep,
	      trace_par_c_.trace_par[i].path,
	      trace_par_c_.trace_par[i].time,
	      trace_par_c_.trace_par[i].tau,
	      rloc,zloc);
    }/* end of debug */

    if(((trace_par_c_.trace_par[i].type ==PRODUCTION && 
       trace_par_c_.trace_par[i].plane == PRODUCTION_PLANE) ||
       (trace_par_c_.trace_par[i].type ==CENTRAL &&
	(int)(sqrt(trace_par_c_.trace_par[i].w.x * 
		   trace_par_c_.trace_par[i].w.x +
		   trace_par_c_.trace_par[i].w.y * 
		   trace_par_c_.trace_par[i].w.y )+ 0.5)
        == (int)(CTOF_R)) ||
       (trace_par_c_.trace_par[i].type ==FORWARD &&
	(int)(trace_par_c_.trace_par[i].w.z +.5) == (int)(FTOF_Z))) &&
       trace_par_c_.trace_par[i].w.q){
      /* 
       * we have a TOF trace 
       */
      haveIt=1;
      tmp_trace[trace_num] = trace_par_c_.trace_par[i];
      trace_num++;
    }
    /*
     * Get the Cerenkov trace points
     */
    if(trace_par_c_.trace_par[i].type ==FORWARD && 
       (int)(trace_par_c_.trace_par[i].w.z +.5) == (int)(CERENKOV_Z)){
      /* 
       * we have a CERENKOV trace point 
       */
      haveIt=1;
      tmp2_trace[trace_num2] = trace_par_c_.trace_par[i];
      trace_num2++;
    }
    if(Debug==1&&haveIt==1){    
      zloc=trace_par_c_.trace_par[i].w.z;
      rloc=sqrt(trace_par_c_.trace_par[i].w.x * 
		trace_par_c_.trace_par[i].w.x +
		trace_par_c_.trace_par[i].w.y * 
		trace_par_c_.trace_par[i].w.y);	
      fprintf(stderr,
	      "typ: %d plane: %d nhit: %d hep: %d path: %lf time: %lf tau: %lf loc(r,z): %lf %lf q:%lf\n",
	      trace_par_c_.trace_par[i].type,
	      trace_par_c_.trace_par[i].plane,
	      trace_par_c_.trace_par[i].hit,
	      trace_par_c_.trace_par[i].hep,
	      trace_par_c_.trace_par[i].path,
	      trace_par_c_.trace_par[i].time,
	      trace_par_c_.trace_par[i].tau,
	      rloc,zloc,trace_par_c_.trace_par[i].w.q );
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
   * Get the tracking hits for devtype 3 devnum 1
   */
  /* VTX Hits */
  if(usr_hits(3,1,&devhits)){ } 
    /* we have some hits */

  
  /* CDC Hits */
  usr_hits(3,2,&devhits_cdc); 

  /*
   *  Get the Colorimetry hits
   * Calorimetry Debug=3
   */
  if(Debug==3)
    usr_dumpCalor();
  usr_calor(&(event.calor0));
 
  /* 
  { * This is old code and not used in HDFast after 1 Apr 1999.
   * It will eventually be remove after the new mcfast code
   * is well verified.
   *
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
	**************** Now dump cal info ***************
	fprintf(stderr,
		"coord1 cell#: %d coord2 cell#: %d e_mip: %f  e_em: %f  e_had: %f\n",
		hit->icr1,hit->icr2,hit->e_mip,hit->e_em,hit->e_had);
	fprintf(stderr,"Ntracks: %d status: %d\n",hit->n_tracks,hit->status);
	for (j=0, tr=hit->info_tr; j<hit->n_tracks; j++, tr++) 
	  fprintf(stderr,"\ttrackNum: %d percent_e_tot: %f\n",tr->tr_num,tr->percent_e_tot);
	fprintf(stderr,"\n");
      }
    }
  }*******************/




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

  event.ctraces.ntraces= trace_num2;
  event.ctraces.trace_par= tmp2_trace;
  
  
  /* 
  event.calor0.nCalHits =  MCFNumHitCal[0];
  event.calor0.CalorHits = MCFCalorHitss[0];
  */


  /*
   * event.calor1.nCalorHitss = MCFNumHitCal[1];
   * event.calor1.CalorHits = MCFCalorHitss[1];  
   */
  event.lgdSmears = LgdParts;
  
  /*
   * set device hits pointers.
   */
  event.devhits = &devhits; 

  event.devhits_cdc = &devhits_cdc; 
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
 /*
   * Free the calor pointer memory
   */
  for(i=0;i<event.calor0.nCalHits;i++){
    free(event.calor0.CalorHits[i]->info_tr);
    free(event.calor0.CalorHits[i]);
  }
  free(event.calor0.CalorHits);
}

