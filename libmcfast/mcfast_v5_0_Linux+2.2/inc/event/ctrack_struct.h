#ifndef CTRACK_STRUCT_H
#define CTRACK_STRUCT_H

/*

    Helix track parametrization, useful in solenoidal field.

    Equations of motion of track, assuming B field along z direction, are

      x = xp + (u0/rho)*sin(ps) - (v0/rho)*[1 - cos(ps)]
      y = yp + (v0/rho)*sin(ps) + (u0/rho)*[1 - cos(ps)]
      z = zp + ct*sperp

      Px = Px0*cos(ps) - Py0*sin(ps)
      Py = Py0*cos(ps) + Px0*sin(ps)
      Pz = Pz0

    where  (xp,yp,zp) is a point on the helix
            u0 = Px0 / Pt
            v0 = Py0 / Pt
            ct = Pz0 / Pt
           (Px0,Py0,Pz0) is the momentum at (xp,yp,zp)
            rho = 2 * cu = 1/R
            sperp = arc length in r-phi plane from (xp,yp,zp)
            ps  = rho * sperp

    When (xp,yp,zp) is the PCA to the reference point, they are given by

      xp = -da * v0 + xref
      yp = +da * u0 + yref
      zp = z0 + zref

   -------------------------------------------------------
   WARNING: if you change this file, also make sure you change 
            ctrack_struct.inc !
   -------------------------------------------------------- 

*/

#include "const.h"


#define CTRACK_NPAR  5

static const int CTRACK_WORD     = 13*FLOAT_WORD;
static const int CTRACK_COV_SIZE = CTRACK_NPAR*CTRACK_NPAR*FLOAT_WORD;

typedef struct _ctrack_s *ctrack_ptr;

typedef struct _ctrack_s {
        DFLOAT cu;     /* 1/2R                                */
        DFLOAT phi0;   /* phi at PCA to reference point       */
        DFLOAT da;     /* DCA to reference point (signed)     */
        DFLOAT ct;     /* cot(theta)                          */
        DFLOAT z0;     /* z - zref at PCA to reference point  */
        DFLOAT u0;     /* cos(phi0)                           */
        DFLOAT v0;     /* sin(phi0)                           */
        DFLOAT pt;     /* Pt                                  */
        DFLOAT p;      /* Momentum                            */
        DFLOAT q;      /* Charge                              */
        DFLOAT xref;   /* x of reference point                */
        DFLOAT yref;   /* y of reference point                */
        DFLOAT zref;   /* z of reference point                */

} ctrack_s; 

static const int jccu  = 0;
static const int jcphi = 1;
static const int jcda  = 2;
static const int jcct  = 3;
static const int jcz0  = 4;

#endif

/*
 * $Id$
 *
 * $Log$
 * Revision 1.1  2000/06/19 19:58:36  eugenio
 * Initial revision
 *
 * Revision 1.1  1998/11/13 21:36:34  kutschke
 * New file. Clone of ctrack_struct.inc
 *
 *
 */
