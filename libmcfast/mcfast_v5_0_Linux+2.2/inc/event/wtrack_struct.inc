#ifndef WTRACK_STRUCT
#define WTRACK_STRUCT

c    Track parametrization in W form (4-momentum + position)

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change 
c            wtrack_struct.hh and wtrack_struct.h !
c -------------------------------------------------------------

#include "const.inc"

      integer WTRACK_WORD, WTRACK_NPAR
      parameter (WTRACK_WORD = 10*FLOAT_WORD)
      parameter (WTRACK_NPAR = 7            )

      structure /wtrack_struct/
        DFLOAT px      !Px
        DFLOAT py      !Py
        DFLOAT pz      !Pz
        DFLOAT E       !E
        DFLOAT x       !x
        DFLOAT y       !y
        DFLOAT z       !z
        DFLOAT pt      !Pt = sqrt(px**2 + py**2)
        DFLOAT p       !Momentum
        DFLOAT q       !Charge
      end structure

c     Constants to identify locations in W track covariance matrix

      integer jwpx, jwpy, jwpz, jwe, jwx, jwy, jwz
      parameter (jwpx = 1)
      parameter (jwpy = 2)
      parameter (jwpz = 3)
      parameter (jwe  = 4)
      parameter (jwx  = 5)
      parameter (jwy  = 6)
      parameter (jwz  = 7)


c ======================================================================
c Comments, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:39  eugenio
c Initial revision
c
c Revision 1.5  1998/11/11 04:00:27  kutschke
c Define WTRACK_NPAR.
c
c Revision 1.4  1998/09/15  04:31:02  kutschke
c Update comments.
c
c Revision 1.3  1997/03/15  19:07:01  mkl
c moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
c fixed rcs comment headers from # to c.
c used cvs admin -c to change default rcs comment headers for .inc files.
c
c Revision 1.2  1997/03/14  22:50:39  mkl
c imported .hh files for equivalent .inc files for Martin Lohner's c++ tracing code
c

#endif
