/************************************************
 * trace.h 
 * Map FORTRAN common block to C data structure
 * Paul Eugenio
 * Carnegie Mellon University
 * 28 Oct 98
 **********************************************/
#ifndef TRACE_CHEADER
#define TRACE_CHEADER

#include"offline_track.h"

struct trace_s {
  int hep;            /* Position of track in /HEPEVT/ list */
  int type;           /* Trace type (see trace_type.inc) */
  int plane;          /* Radial or z plane number */
  int hit;            /* hit index  (NOTE MCFast comments called this nhits)*/
  struct wtrack_struct w;  /* Track parameters at interaction */
  double eta[3];      /* Direction cosines of normal to plane */
  double path;        /* Total track length up to this hit */
  double time;        /* Time at which track made hit */
  double tau;         /* Proper flight time to intersection */
  int material;       /* Position in material list */
  double radl;        /* # of radiation lengths in material */
  double dedx;        /* dE/dx of material */
} ;


#define TRACE_MAX 20000

struct trace_par_c {
  int trace_num;      /* Number of track intersections */
  int trace_num_dum;  /* dummy for alignment */
  struct trace_s trace_par[TRACE_MAX];
} ;

extern struct trace_par_c trace_par_c_ ;


#endif
