/************************************************
 * read_output.c 
 *
 * This is a simple test program used to read the 
 * the *.cat file produced by usr_dump.c
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



main(int argc,char **argv){

  /* data struct to read to */
  int nevhep,nhep;
  struct heppart_t *heppart;
  int trk_off_num;
  struct offline_track_struct *trk_off;
  int trace_num;
  struct trace_s *trace;


  char outfile[50]="mcfast.cat";
  FILE *fpt=NULL;
  static int firstEvent=1;
  int count=0,i;


  if(firstEvent){
    firstEvent=0;
    fprintf(stderr,"to open\t");
    fpt = fopen(outfile,"r");
    fprintf(stderr," opened\t");
  }
  /*************** READ IN ORDER OF WRITE ********************* 
       **** hepevt data ****
  fwrite(&nevhep,sizeof(int),1,fpt);
  fwrite(&nhep,sizeof(int),1,fpt);
  fwrite(heppart,sizeof(struct heppart_t)*nhep,1,fpt); 
       **** write offline track data ****
  fwrite(&trk_off_num,sizeof(int),1,fpt);
  fwrite(trk_off,sizeof(struct offline_track_struct)*trk_off_num,1,fpt); 
       **** write trace data ****
  fwrite(&trace_num,sizeof(int),1,fpt);
  fwrite(trace,sizeof(struct trace_s)*trace_num,1,fpt); 
  ******************************************************/


 
  while (fread(&nevhep,sizeof(int),1,fpt)){

    fread(&nhep,sizeof(int),1,fpt);
    heppart = malloc(sizeof(struct heppart_t)*nhep);
    fread(heppart,sizeof(struct heppart_t)*nhep,1,fpt);
    fread(&trk_off_num,sizeof(int),1,fpt);
    trk_off = malloc(sizeof(struct offline_track_struct )*trk_off_num);
    fread(trk_off,sizeof(struct offline_track_struct)*trk_off_num,1,fpt);
    fread(&trace_num,sizeof(int),1,fpt);
    trace = malloc(sizeof(struct trace_s )*trace_num);
    fread(trk_off,sizeof(struct trace_s)*trace_num,1,fpt);

    count++;
    fprintf(stderr,"count: %d",count);
    fprintf(stderr,"\t nevent: %d nhep: %d \n",nevhep,nhep);
    for(i=0;i<nhep;i++){
      fprintf(stderr,"\tid: %d",heppart[i].idhep); 
    }
     fprintf(stderr,"\n");

     /* Now free the data */
     free(heppart);
     free(trk_off);
     free(trace);
  }
}
