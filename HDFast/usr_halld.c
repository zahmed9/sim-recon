/************************************************
 * usr_halld.c 
 * This routine is called from usr_analysis.F to
 * write out the smeared mc tracks to stdhep format.
 * Paul Eugenio
 * Carnegie Mellon University
 * 28 Sept 98
 **********************************************/

#include<stdio.h>
#include <stdlib.h>

#include<stdhep.h>
#include<stdlun.h>
#include<stdcnt.h>
#include<offline_track.h>

/********************************
 * Prototypes for StdHep functions.
 *********************************/

int StdHepXdrWiteInit(char *fileName,char *title, int ntries, int istream);
int StdHepXdrWrite(int ilbl,int istream);
int StdHepXdrEnd(int istream);


/******************
 *  Local Structure
 ******************/
typedef struct { double x,y,z; } dvector3_t;
typedef struct { double t; dvector3_t space; } dvector4_t;

typedef struct {
  int statusCode; /* 1 is a final state particle */
  int pid; /* this use the PDG MC numbering scheme */
  double mass;
  dvector4_t p; /* four momentum */
  dvector3_t v; /* a point on the track */ 
}mc_part_t;

/********************************
 * Local Prototypes 
 *********************************/
int fill_hepevt(int nparts, mc_part_t *parts);


#define MAX_PARTS 2000
#define MAX_NTRIES 1000
void pri_(int *nrec,int *nhep,int *trk_off_num,int *trk_gen_num){
  fprintf(stderr,"nrec= %d  nhep= %d  trk_off_num= %d  trk+gen_num=%d\n",
	  *nrec, *nhep, *trk_off_num, *trk_gen_num);
}
void usr_halld_(int *nrec){
  int ret;
  static int written=0;
  mc_part_t parts[MAX_PARTS];
  int ilbl=1,istream=3,ntries = MAX_NTRIES;
  char *title="Halld MCFast output";
  char *outputfile="halldMCFasted.evt";


  /*
   * FOR TEST ONLY
   */
  fprintf(stderr,"\n\n\tNREC is %d\n\n",*nrec);
  /* *nrec=5; */
  /*
   * get the fortran common block structure
   */
  
  fill_parts(*nrec,parts);
  
  /*
   * fill the stdhep event stucture
   */
  fill_hepevt(*nrec, parts);
   
  /*
   * write the stdhep event to file
   */
  /* ret=StdHepXdrWrite(ilbl,istream); */
  if(!(++written %100))
    fprintf(stderr,"McFast events Written: %d\r",written);

}
/********************
 * fill_parts
 *******************/

int fill_parts(int nparts, mc_part_t *part){
  int i;
  extern struct trk_off2 trk_off2_ ;

  for(i=0;i<nparts;i++){ 
    part[i].pid = hepevt_.idhep[trk_off2_.trk_off[i].hep];
    part[i].statusCode = hepevt_.isthep[trk_off2_.trk_off[i].hep];
    part[i].mass = trk_off2_.trk_off[i].mass;
    part[i].p.space.x = trk_off2_.trk_off[i].w.px;
    part[i].p.space.y = trk_off2_.trk_off[i].w.py;
    part[i].p.space.z = trk_off2_.trk_off[i].w.pz;
    part[i].p.t = trk_off2_.trk_off[i].w.E;
    part[i].v.x = trk_off2_.trk_off[i].w.x;
    part[i].v.y = trk_off2_.trk_off[i].w.y;
    part[i].v.z = trk_off2_.trk_off[i].w.z;
  }
  return 1;
}

/********************
 * fill_hepevt
 *******************/
int fill_hepevt(int nparts, mc_part_t *part){
  int i;
  static int nevent=0,debug=0;
  
  nevent++;
  /* hepevt header info */
  hepevt_.nevhep=nevent;
  hepevt_.nhep=nparts;
  if(debug>1)
    fprintf(stderr,"EventNo: %d\n",nevent);
  /* now loop over the particle in the event */
  
    
  for(i=0;i<nparts;i++){
    hepevt_.isthep[i]=part[i].statusCode;
    hepevt_.idhep[i]=part[i].pid;
    hepevt_.phep[i][0]=part[i].p.space.x;
    hepevt_.phep[i][1]=part[i].p.space.y;
    hepevt_.phep[i][2]=part[i].p.space.z;
    hepevt_.phep[i][3]=part[i].p.t;
    hepevt_.phep[i][4]=part[i].mass;
    hepevt_.vhep[i][0]=part[i].v.x;
    hepevt_.vhep[i][1]=part[i].v.y;
    hepevt_.vhep[i][2]=part[i].v.z;
    /* file the left overs */
    /* hepevt_.jmohep[i]  */
    debug=1;
    if(debug){
      fprintf(stderr,"staus Code: %d   pid: %d  mass: %lf\n",
	part[i].statusCode,part[i].pid,part[i].mass);
       fprintf(stderr,"4 momentum: %lf %lf %lf %lf\n",
	       part[i].p.space.x,part[i].p.space.y,
	       part[i].p.space.z,part[i].p.t);
       fprintf(stderr,"vert: %lf %lf %lf\n",part[i].v.x,
	       part[i].v.y,part[i].v.z);
    }
  }
  return 1; 
}
