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
#include<calor_hits.h>
#include<usr_lgd.h>
//#include <dev_hit.h>
//#include <hit_track.h>


struct offline_track_struct *trk_off;
struct trace_s *trace,*trace_point,tmp_trace[50],tmp2_trace[20];
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
  struct ntraces_t traces;    // defined in TMCFastTraceEvent.h 
  struct hepevt_t  mcevt;  // defined in TMCFastHepEvt.h 
  struct ntrkoff_t offtrk;  // defined in TMCFastOfflineTrack.h 
  struct cal_hits_t calor0; // defined in TMCFastCalorimeter.h 
  lgd_smearedparts_t *lgdSmears;  
  //  struct dev_hits_t *devhits; 
  //struct dev_hits_t *devhits_cdc;  
};

//int usr_hits(int devtype,int devnum,struct dev_hits_t *devhits);
void usr_calor(struct cal_hits_t *Calor);

void usr_dump(void){ 
  
  int i,j;
  double rloc,zloc;
   
  int trk_off_num=0;
  int trace_num=0,trace_num2=0,ntrace_points;
  int nevhep,nhep=0;
  extern int Debug,SaveUsingMCFIO;
  struct event_t event;
  extern lgd_smearedparts_t *LgdParts;

  //int devtype, devnum;
  //struct dev_hits_t devhits;
  //struct dev_hits_t devhits_cdc;
  /*
   * Allocate memory and copy the hepevt_ common block (i.e. the mc input )
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
   * Allocate mem and copy the trk_off1_ common block (i.e. the smeared tracks)
   */
  trk_off_num=trk_off_c_.trk_off_num;
  trk_off = malloc(sizeof(struct offline_track_struct)*trk_off_num);
		   
  for(i=0;i<trk_off_num;i++)
    trk_off[i] = trk_off_c_.trk_off[i];


  /*
   * Allocate mem and copy traces
   * from the trace_par_c_ common block
   */


  // 
  // alocate and copy
  //
  ntrace_points = trace_par_c_.trace_num;
  trace_point = malloc(sizeof(struct trace_s)*ntrace_points);
  
  for(i=0;i< ntrace_points;i++){
    // if(trace_par_c_.trace_par[i].hit != 0) // Kludge fix the hits (they are missing the the trace index) 
                                           // for consistency use FORTRAN indexology i.e. start w/ 1
      //  hit_trk_c_.hit_trk[trace_par_c_.trace_par[i].hit - 1].trace = i+1;
    
    
    
    trace_point[i]=trace_par_c_.trace_par[i];
    if(Debug==2) 
      fprintf(stderr,
	      "trace typ: %d plane: %d hit: %d hep: %d path: %lf time: %lf tau: %lf \n",
	      trace_point[i].type,
	      trace_point[i].plane,
	      trace_point[i].hit,
	      trace_point[i].hep,
	      trace_point[i].path,
	      trace_point[i].time,
	      trace_point[i].tau);
    
  }

  //
  // Get the tracking hits for devtype 3 devnum 1
   //
  // VTX Hits
  //if(usr_hits(3,1,&devhits)){ } 
  // we have some hits

  
  // CDC Hits 
  //usr_hits(3,2,&devhits_cdc); 




  //
  //  Get the Colorimetry hits
  // Calorimetry Debug=3
  //
  if(Debug==3)
    usr_dumpCalor();


  //
  // Now set the event pointers.
  //

  usr_calor(&(event.calor0)); //  Get the Colorimetry hits
 
  event.mcevt.nevhep= nevhep;
  event.mcevt.nhep= nhep;
  event.mcevt.heppart= heppart;
  
  event.offtrk.ntracks= trk_off_num;
  event.offtrk.trk_off= trk_off;
  
  event.traces.ntraces= ntrace_points;
  event.traces.trace_par= trace_point;

  event.lgdSmears = LgdParts;
  
  ///
  // set device hits pointers.
  ///
  //event.devhits = &devhits; 

  //event.devhits_cdc = &devhits_cdc; 
  

  //
  // Create C++ objects and save 
  // them to a ROOT Tree.
  //
  usr_mcfast2root(&event);

   
  // Free the allocated memory
  //
   free(heppart);
   free(trk_off);
   free(trace_point);
 
   // Free the calor pointer memory   
  for(i=0;i<event.calor0.nCalHits;i++){
    free(event.calor0.CalorHits[i]->info_tr);
    free(event.calor0.CalorHits[i]);
  }
  free(event.calor0.CalorHits);
}

