#ifndef ZPLANE_TYPES
#define ZPLANE_TYPES

c   Types of z planes

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change 
c            zplane_types.hh!
c -------------------------------------------------------------

      integer jzpl_drift
      integer jzpl_sidisk
      integer jzpl_material
      integer jzpl_magnet
      integer jzpl_emcal
      integer jzpl_hcal
      integer jzpl_siz_rect
      integer jzpl_siz_circ
      parameter (jzpl_drift = 1)      !Drift chamber layer
      parameter (jzpl_sidisk = 2)     !Silicon disk
      parameter (jzpl_material = 3)   !Cylinder material
      parameter (jzpl_magnet = 4)     !Magnet boundary
      parameter (jzpl_emcal = 5)      !Emcal boundary
      parameter (jzpl_hcal = 6)       !Hcal boundary
      parameter (jzpl_siz_rect = 7)   !Silicon rectangular xy plane
      parameter (jzpl_siz_circ = 8)   !Silicon circular xy plane
      


c ======================================================================
c Comments, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:40  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 01:38:57  mcbride
c  fix up zplane types to include siz_rect structures
c
c Revision 1.2  1997/03/27  22:23:18  mkl
c cvs admin -c'c ' r/zplane_types.inc
c
c Revision 1.1  1997/03/27  22:03:03  mkl
c moved detector-defining parameter statements out of r/zplane_struct.inc 
c  into r/zplane_types.inc/.hh
c
c

#endif /* ZPLANE_TYPES */
