/************************************************
 * usr_output.c 
 *
 * Paul Eugenio
 * Carnegie Mellon University
 * 1 Nov 98
 **********************************************/

#include<stdio.h>
#include <stdlib.h>

#include<stdhep_alloc.h>
#include<stdlun.h>
#include<stdcnt.h>
#include<offline_track.h>
#include<trace.h>



int usr_output(int nevhep, int nhep,struct heppart_t *heppart,
	       int trk_off_num, struct offline_track_struct *trk_off,
	       int trace_num, struct trace_s *trace ){

  extern char Outfile_HallD[50]; /*="test.cdt";*/
  static FILE *fpt=NULL;
  static int firstEvent=1;

  if(firstEvent){
    firstEvent=0;
    fprintf(stderr,"Opening C-data file: %s\n",Outfile_HallD);
    fpt = fopen(Outfile_HallD,"w");
  }

  /* 
   * write data in this order so
   * that we can read the int's and
   * allocate the right amount of memory
   */

  /* write hepevt data */
  fwrite(&nevhep,sizeof(int),1,fpt);
  fwrite(&nhep,sizeof(int),1,fpt);
  fwrite(heppart,sizeof(struct heppart_t)*nhep,1,fpt); 

  /* write offline track data */
  fwrite(&trk_off_num,sizeof(int),1,fpt);
  fwrite(trk_off,sizeof(struct offline_track_struct)*trk_off_num,1,fpt); 

   /* write trace data */
  fwrite(&trace_num,sizeof(int),1,fpt);
  fwrite(trace,sizeof(struct trace_s)*trace_num,1,fpt); 
  

}
