      subroutine vtx_add

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Add location of primary vertex to all particles in /HEPEVT/.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "stdhep.inc"
#include "vtxhep.inc"
#include "beam_vertex.inc"
#include "prim_vertex.inc"

c     Local variables
      integer i, ihep, ivtx
      DFLOAT conv
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Add primary vertex position to all particles in /HEPEVT/
c     Remember that there might be more than one vertex if multiple
c     interactions were turned on.
c     /HEPEVT/ uses mm (nonstandard!). Convert to our units, defined in
c     "const.inc"
      conv = 1.0 / (0.001*unit_meter)
      do ihep=1,nhep
        do i=1,4
          ivtx = jmulti(ihep)
          vhep(i,ihep) = vhep(i,ihep) + prim_vertex(i,ivtx) * conv
        enddo
      enddo

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:59  garren
c add hooks to initialize user trigger code
c
