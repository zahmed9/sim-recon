#ifndef MKL_TRACE_STRUCT
#define MKL_TRACE_STRUCT

c Track intersections

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change 
c            TraceStruct.hh!
c -------------------------------------------------------------

#include "const.inc"

      integer nhyp
      parameter( nhyp=5 )

      structure /mkl_trace_struct/
C
C       Seperate the DFLOAT portions from the integer portions
C        to avoid different padding from C++ and Fortran on 
C        different platforms
C
        DFLOAT ref_x               !x of reference point 
        DFLOAT ref_y               !y of reference point 
        DFLOAT ref_z               !z of reference point 

        DFLOAT path                !Total track length up to this hit
        DFLOAT time                !Time at which track made hit
        DFLOAT tau                 !Proper flight time to intersection
 
        DFLOAT radl                !# of radiation lengths of material
        DFLOAT dedx                !dedx of material
C
C  the following is only filled, because of some tracking routines
C
        DFLOAT  eta(3)             !Direction cosines of normal to plane
C
C      
c not used anymore
c        DFLOAT sigma_ms(nhyp)      !RMS MS angle per particle type
c        DFLOAT eloss(nhyp)         !dE/dx per particle type


        integer material           !Position in material list
        integer hep                !Position of track in /HEPEVT/ list
C
C  the following two are only filled, because of some tracking routinesa
C
        integer type               !Trace type (see trace_type.inc)
        integer plane              !plane index into common block array

      end structure



c ======================================================================
c Comments, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:34  eugenio
c Initial revision
c
c Revision 1.4  1999/03/12 18:55:03  procario
c Move all doubles to the beginning of the structure so that padding will not be an issue
c
c Revision 1.3  1998/10/21  19:59:40  mkl
c implement eta correctly
c
c Revision 1.2  1997/11/21  04:15:46  mkl
c write traces for material planes even when MS/Eloss flags aren't set
c
c Revision 1.1.1.1  1997/03/14  22:52:34  mkl
c Imported sources for Martin Lohner s new c++ tracing code
c

#endif
