#ifndef PRIM_VERTEX_INC
#define PRIM_VERTEX_INC

c
c   Rob Kutschke, Sept 24, 1998.
c
c   Generated primary vertex positions for each interaction in this
c   beam crossing.
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change 
c            prim_vertex.h !
c
c   -------------------------------------------------------- 
c

#include "const.inc"

      integer prim_maxvtx
      parameter (prim_maxvtx = 100)

      integer prim_numvtx       !Number of primary vertices
      DFLOAT prim_vertex        !Primary vertex (cm)
      integer idm_pmvt          ! alignment dummy
      common/prim_vertex_c/ prim_numvtx, idm_pmvt,
     +  prim_vertex(4,prim_maxvtx)

#endif
