/************************************************
 * usr_trace.c 
 * This routine is called from usr_analysis.F to
 * write out the trace information.
 * Paul Eugenio
 * Carnegie Mellon University
 * 28 Oct 98
 **********************************************/

#include<stdio.h>
#include <stdlib.h>
#include<math.h>

#include<stdhep.h>
#include<stdlun.h>
#include<stdcnt.h>
#include<offline_track.h>
#include<trace.h>


struct event_t {
  struct trace_par_c trace;
  struct hepevt mcevt;
  struct trk_off_t offtrk;
} evt; 

int usr_output(struct event_t *evt);

void usr_trace(void){ 
  
  int i;
  double loc;
  /* Map of trace FORTRAN common block (see trace.h) */
  extern struct trace_par_c trace_par_c_ ;

  evt.offtrk.trk_off_num=trk_off1_.trk_off_num;
  for(i=0;i<evt.offtrk.trk_off_num;i++)
    evt.offtrk.trk_off[i] = trk_off2_.trk_off[i];

  evt.trace=trace_par_c_;
  evt.mcevt=hepevt_;

  usr_output(&evt); 
  
  for(i=0;i<trace_par_c_.trace_num;i++){

    if(trace_par_c_.trace_par[i].type==2)
      loc=trace_par_c_.trace_par[i].w.z;
    else{

      loc=sqrt(trace_par_c_.trace_par[i].w.x * trace_par_c_.trace_par[i].w.x +
	       trace_par_c_.trace_par[i].w.y * trace_par_c_.trace_par[i].w.y);
	       
    }
    
    fprintf(stderr,
	    "typ: %d plane: %d nhit: %d path: %lf time: %lf loc: %lf \n",
	    trace_par_c_.trace_par[i].type,
	    trace_par_c_.trace_par[i].plane,
	    trace_par_c_.trace_par[i].hit,
	    trace_par_c_.trace_par[i].path,
	    trace_par_c_.trace_par[i].time,
	    loc
);
  }

}
