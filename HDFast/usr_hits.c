/************************************************
 * usr_hits.c 
 * This routine is called from usr_analysis.c 
 * to dump the mcfast chamber hits.
 * 
 *
 * Paul Eugenio
 * Carnegie Mellon University
 * 15 Mar 1999
 **********************************************/

#include<stdio.h>
#include <stdlib.h>
#include <trace.h>  
#include <dev_hit.h>
/******************
 * dev_hit.h defines:
 * struct dev_hit_t{
 *  int layer;
 *  int wire_info[3];
 *  struct trace_s trace;
 * };
 *
 * struct dev_hits_t{
 *   int nhits;
 *   struct dev_hit_t devhit[50];
 * }; 
 *******************/

#include <hit_track.h> 
/***************************************************************
 * hit_track.h defines:
 * #define hit_trk_max 10000   *  define the dimension parameter *
 *
 * extern struct hit_trk_c {
 * int hit_trk_num;                    * Number of hits.  *
 * int idm_httk;                       * Alignment dummy. *
 * hit_trk_s hit_trk[hit_trk_max];
 * } hit_trk_c_;
 *
 **************************************************************/

void copy_trace(struct trace_s *source,struct trace_s *dest);

int usr_hits(int devtype,int devnum,struct dev_hits_t *devhits){  
  /*
   * This function must be called
   *  after calling the mcfast
   * tracking routines.
   */

  int i,j,traceIndex;
  extern int Debug;
  extern struct hit_trk_c hit_trk_c_;
  double x=0,y=0,z=0,r=0;
  int nhits= hit_trk_c_.hit_trk_num;
  

  devhits->nhits=0;
  if(Debug == 7)/* use 7 */
    fprintf(stderr,"Found %d detector hits\n",nhits);
  for(i=0;i<nhits;i++){
    if(hit_trk_c_.hit_trk[i].chan.devtype == devtype &&
       hit_trk_c_.hit_trk[i].chan.devnum == devnum){
      if(Debug == 7)/* use 7 */
	fprintf(stderr,"hep %d trace %d devtype %d devnum %d devlayer %d devwid[3] %d %d %d channel %d\n",
	      hit_trk_c_.hit_trk[i].hep,
	      hit_trk_c_.hit_trk[i].trace,
	      hit_trk_c_.hit_trk[i].chan.devtype,
	      hit_trk_c_.hit_trk[i].chan.devnum,
	      hit_trk_c_.hit_trk[i].chan.devlayer,
	      hit_trk_c_.hit_trk[i].chan.devwid[0],
	      hit_trk_c_.hit_trk[i].chan.devwid[1],
	      hit_trk_c_.hit_trk[i].chan.devwid[2],
	      hit_trk_c_.hit_trk[i].chan.channel);
      /* now dump Trace Point */
      traceIndex = hit_trk_c_.hit_trk[i].trace -1; /* Fortran Indexology*/
      if(Debug == 7)
	fprintf(stderr,"TracePoint:\n\thep %d type %d plane %d hit %d mate %d dedx %f\n",
		trace_par_c_.trace_par[traceIndex].hep,
		trace_par_c_.trace_par[traceIndex].type,
		trace_par_c_.trace_par[traceIndex].plane,
		trace_par_c_.trace_par[traceIndex].hit,
		trace_par_c_.trace_par[traceIndex].material,
		trace_par_c_.trace_par[traceIndex].dedx*1e6);
      x= trace_par_c_.trace_par[traceIndex].w.x;
      y= trace_par_c_.trace_par[traceIndex].w.y;
      z= trace_par_c_.trace_par[traceIndex].w.z;
      r= sqrt(x*x +y*y);
      if(Debug == 7)
	fprintf(stderr,"\tposition (x,y,z): (%f, %f, %f) r: %f\n",
		x,y,z,r);
		      
      if(devhits->nhits+1>MAX_DEVHITS){/* error */
	fprintf(stderr,"devhits->nhits = %d\n",devhits->nhits);
	fprintf(stderr,"devhits->nhits>MAX_DEVHITS must resize array!\n");
	exit(-1);
      }
	/*
	 * fill data structure
	 */
	devhits->devhit[devhits->nhits].layer=
	  hit_trk_c_.hit_trk[i].chan.devlayer;
	for(j=0;j<3;j++)
	  devhits->devhit[devhits->nhits].wire_info[j]=
	    hit_trk_c_.hit_trk[i].chan.devwid[j];
	copy_trace(&(trace_par_c_.trace_par[traceIndex]),
		&(devhits->devhit[(devhits->nhits)++].trace));   
      
    }
  }
  if(Debug == 7)
    fprintf(stderr,"Found %d hits for devnum %d of devtype %d\n",
	    devhits->nhits,devnum,devtype);
  return devhits->nhits;
}

void copy_trace(struct trace_s *source,struct trace_s *dest){ 
  int i;
  
  dest->hep = source->hep;
  dest->type = source->type;  
  dest->plane = source->plane;
  dest->hit = source->hit;
  dest->w.px = source->w.px ;
  dest->w.py = source->w.py ;
  dest->w.pz = source->w.pz ;
  dest->w.e = source->w.e ;
  dest->w.x = source->w.x ;
  dest->w.y = source->w.y ;
  dest->w.z = source->w.z ;
  dest->w.pt = source->w.pt ;
  dest->w.p = source->w.p ;
  dest->w.q = source->w.q ;
  for(i=0;i<3;i++)
      dest->eta[i] = source->eta[i];
  dest->path = source->path ;
  dest->time = source->time ;
  dest->tau = source->tau ;
  dest->material = source->material ;
  dest->radl = source->radl ;
  dest->dedx = source->dedx*1e6 ;
}
