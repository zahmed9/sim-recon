/************************************************
 * dev_hit.h 
 * Map FORTRAN common block to C data structure
 * Paul Eugenio
 * Carnegie Mellon University
 * 17 Mar 1999 (Happy Birthday Dad)
 *
 * also see hit_track.h
 **********************************************/
#ifndef DEVHIT_CHEADER
#define DEVHIT_CHEADER

#include"trace.h"

struct dev_hit_t{
  int layer;
  int wire_info[3];
  struct trace_s trace;
};
#define MAX_DEVHITS 1000
struct dev_hits_t{
  int nhits;
  struct dev_hit_t devhit[MAX_DEVHITS];
};


#endif
