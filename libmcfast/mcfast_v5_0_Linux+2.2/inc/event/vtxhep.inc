#ifndef VTXHEP_INC
#define VTXHEP_INC

c
c   Rob Kutschke, Oct. 20, 1998.
c
c   Stores information about vertices from the StdHep commons.
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change
c            vtxhep.h !
c
c   --------------------------------------------------------
c

#include "const.inc"

      integer ipvhep, idvhep
*
      common /pointhep/ ipvhep(mcf_nmxhep), idvhep(mcf_nmxhep)
      save   /pointhep/
*
*      ipvhep    - pointer to production vertex for stdhep track 
*      idvhep    - pointer to decay vertex for stdhep track 
*
      integer    maxvtx
      parameter (maxvtx = 1000)

      DFLOAT vtx_pos
      integer vtx_intrk, vtx_outrk, vtx_ntrk, vtx_hep_n
*
      common /vtxhep/
     *  vtx_hep_n,
     *  vtx_intrk(maxvtx), 
     *  vtx_outrk(maxvtx),
     *  vtx_ntrk(maxvtx)

      common /vtxhep1/
     *  vtx_pos(4,maxvtx)

      save /vtxhep/

*      vtx_hep_n    - number of vertices stored
*      vtx_intrk    - stdhep track # of incoming track of this vertex
*      vtx_outrk    - stdhep track # of 1st outgoing track of this vertex
*      vtx_ntrk     - number of tracks emerging from this vertex
*      vtx_pos(1,..) - x vertex position
*      vtx_pos(2,..) - y vertex position
*      vtx_pos(3,..) - z vertex position
*      vtx_pos(4,..) - c*production time

#endif
