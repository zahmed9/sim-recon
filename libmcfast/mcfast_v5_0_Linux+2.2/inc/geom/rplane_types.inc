#ifndef RPLANE_TYPES
#define RPLANE_TYPES

c   Types of r planes

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change 
c            rplane_types.hh!
c -------------------------------------------------------------

      integer jrpl_drf_anode
      integer jrpl_drf_cathode
      integer jrpl_sibarrel
      integer jrpl_material
      integer jrpl_magnet
      integer jrpl_emcal
      integer jrpl_hcal
      parameter (jrpl_drf_anode = 1)      !Drift chamber anode
      parameter (jrpl_drf_cathode = 2)    !Drift chamber cathode
      parameter (jrpl_sibarrel = 3)       !Silicon barrel
      parameter (jrpl_material = 4)       !Cylinder material
      parameter (jrpl_magnet = 5)         !Magnet boundary
      parameter (jrpl_emcal = 6)          !Emcal boundary
      parameter (jrpl_hcal = 7)           !Hcal boundary
      


c ======================================================================
c Comments, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:40  eugenio
c Initial revision
c
c Revision 1.2  1997/03/27 22:23:17  mkl
c cvs admin -c'c ' r/zplane_types.inc
c
c Revision 1.1  1997/03/27  22:03:02  mkl
c moved detector-defining parameter statements out of r/zplane_struct.inc
c   into r/zplane_types.inc/.hh
c
c

#endif /* RPLANE_TYPES */
