#ifndef TRACE_STRUCT_INC
#define TRACE_STRUCT_INC

c
c   Rob Kutschke, Sept 24, 1998.
c
c   Description of the intersection of a track with an rplane or
c   a zplane.
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change 
c            trace_struct.h !
c
c   -------------------------------------------------------- 
c

#include "wtrack_struct.inc"

c Track intersections

      structure /trace_s/
        integer hep                !Position of track in /HEPEVT/ list
        integer type               !Trace type (see trace_type.inc)
        integer plane              !Radial or z plane #
        integer hit                !# of hit in hit_track list (0 if none)
        record /wtrack_struct/ w   !Track parameters at intersection
        DFLOAT eta(3)              !Direction cosines of normal to plane
        DFLOAT path                !Total track length up to this hit
        DFLOAT time                !Time at which track made hit
        DFLOAT tau                 !Proper flight time to intersection
        integer material           !Position in material list
	integer dummy              !pad to align structure
        DFLOAT radl                !# of radiation lengths of material
        DFLOAT dedx                !dE/dx of material
      end structure

#endif

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:38  eugenio
c Initial revision
c
c Revision 1.4  1999/11/17 16:54:08  mcbride
c added pad to align structure
c
