#ifndef VTXHEP_H
#define VTXHEP_H

/*

   Rob Kutschke, Oct. 20, 1998.

   Stores information about vertices from the StdHep commons.

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change
            hep_trace.inc !

   --------------------------------------------------------

   ipvhep    - pointer to production vertex for stdhep track 
   idvhep    - pointer to decay vertex for stdhep track 


   vtx_hep_n    - number of vertices stored
   vtx_intrk    - stdhep track # of incoming track of this vertex
   vtx_outrk    - stdhep track # of 1st outgoing track of this vertex
   vtx_ntrk     - number of tracks emerging from this vertex
   vtx_pos(1,..) - x vertex position (cm)
   vtx_pos(2,..) - y vertex position (cm)
   vtx_pos(3,..) - z vertex position (cm)
   vtx_pos(4,..) - c*production time

*/

#include "const.h"


extern struct pointhep{
  int ipvhep[MCF_NMXHEP];
  int idvhep[MCF_NMXHEP];
} pointhep_;

#define maxvtx 1000

extern struct vtxhep{
  int vtx_hep_n;
  int vtx_intrk[maxvtx];
  int vtx_outrk[maxvtx];
  int vtx_ntrk [maxvtx];
} vtxhep_;


extern struct vtxhep1{
   DFLOAT vtx_pos[maxvtx][4];
} vtxhep1_;


#endif
