#ifndef KINE_CNST_S
#define KINE_CNST_S

#include "const.inc"

c  Contains info for non-vertex fits
c
c  dc         constraint matrix for non-vertex constraints (7 x ntrk x mcon)
c  d1c        constant part of non-vertex constraints (mcon)
c  vdc        non-vertex [dm * vx0 * dm(t)](inv) (mcon x mcon)
c  dcvx       dm * vx0 for non-vertex constraints (7 x ntrk x ncom)
c  lamc0      initial lagrange multipliers for non-vertex constraints (mcon)
c  lamc       lagrange multipliers for non-vertex constraints (mcon)

      integer mcon
      parameter (mcon = 4)

      structure /kine_cnst_s/
        DFLOAT dc(7)
        DFLOAT d1c
        DFLOAT dcvx(7)
        DFLOAT lamc0
        DFLOAT lamc
      end structure

      DFLOAT vdc
      record /kine_cnst_s/ kine_cnst
      common /kine_cnst_c/ kine_cnst(mcon), vdc(mcon,mcon)

#endif
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:58:37  eugenio
c Initial revision
c
c Revision 1.2  1998/04/27 01:28:34  kutschke
c New file.
c
c
