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

struct offline_track_struct *trk_off;
struct trace_s *trace,tmp_trace[TRACE_MAX];
struct heppart_t *heppart;

int usr_output(int nevhep, int nhep,struct heppart_t *heppart,
	       int trk_off_num, struct offline_track_struct *trk_off,
	       int trace_num, struct trace_s *trace ); 

void usr_dump(void){ 
  
  int i,j,debug=0;
  double rloc,zloc;
   
  int trk_off_num=0;
  int trace_num=0;
  int nevhep,nhep=0;


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
    if((trace_par_c_.trace_par[i].type ==PRODUCTION && 
       trace_par_c_.trace_par[i].plane == PRODUCTION_PLANE) ||
       (trace_par_c_.trace_par[i].type ==CENTRAL &&
	(int)(trace_par_c_.trace_par[i].w.x * trace_par_c_.trace_par[i].w.x +
	      trace_par_c_.trace_par[i].w.y * trace_par_c_.trace_par[i].w.y)
        == (int)(CTOF_R*CTOF_R)) ||
       (trace_par_c_.trace_par[i].type ==FORWARD &&
	(int)(trace_par_c_.trace_par[i].w.z) == (int)(FTOF_Z))){
      /* we have a TOF trace */

      tmp_trace[trace_num] = trace_par_c_.trace_par[i];
      trace_num++;
    
      if(debug){    
	zloc=trace_par_c_.trace_par[i].w.z;
	rloc=sqrt(trace_par_c_.trace_par[i].w.x * 
		  trace_par_c_.trace_par[i].w.x +
		  trace_par_c_.trace_par[i].w.y * 
		  trace_par_c_.trace_par[i].w.y);	
	fprintf(stderr,
	 "typ: %d plane: %d nhit: %d path: %lf time: %lf loc(r,z): %lf %lf \n",
		trace_par_c_.trace_par[i].type,
		trace_par_c_.trace_par[i].plane,
		trace_par_c_.trace_par[i].hit,
		trace_par_c_.trace_par[i].path,
		trace_par_c_.trace_par[i].time,
		rloc,zloc);
      }
    }
  }
  /* alocate and copy */
  trace = malloc(sizeof(struct trace_s)*trace_num);
  for(i=0;i<trace_num;i++)
    trace[i]= tmp_trace[i];
  
  usr_output(nevhep, nhep,heppart,
	     trk_off_num, trk_off,
	     trace_num, trace ); 
  
}
