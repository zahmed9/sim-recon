      integer function trk_brem_photon(hep, w, path)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Creates a photon generated from a bremmstrahlung event
c
c  Inputs:
c  hep       integer variable
c            Position in HEPEVT list of bremming particle (parent)
c
c  w         w track structure
c            Track parameters in w format
c
c  path      path structure
c            Path information
c
c  Return:
c            0 if all OK
c            1 if HEPEVT or vertex list too large
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "path_struct.inc"
#include "stdhep.inc"
#include "vtxhep.inc"

c     Externals

c     Calling arguments
      integer hep
      record /wtrack_struct/ w
      record /path_struct/ path

c     Local variable
      integer put
      DFLOAT p4(5,2), conv
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Room enough in HEPEVT list
      if(nhep .ge. nmxhep) goto 9999

c     Room enough in vtxhep list
      if(vtx_hep_n .ge. maxvtx) goto 9999

      put = nhep + 1
      nhep = put

      phep(1,put) = w.px
      phep(2,put) = w.py
      phep(3,put) = w.pz
      phep(4,put) = sqrt(phep(1,put)**2 + phep(2,put)**2
     *                 + phep(3,put)**2)
      phep(5,put) = 0.

c     Set mothers but DO NOT set daughters of the parent electron.
c     (may have several brem events along one photon)
      jmohep(1,put) = hep
      jmohep(2,put) = 0

c     Zero daughters of the brem'ed photon.
      jdahep(1,put) = 0
      jdahep(2,put) = 0

c     Mark that this photon has brem'ed.
      isthep(hep) = ISTHEP_BREM

c     Status and particle IDs
      isthep(put) = 1
      idhep(put) = 22

c     Vertex information
      vtx_hep_n = vtx_hep_n + 1

c     Store in mm
      conv = 1000. / unit_meter
      vhep(1,put) = w.x * conv
      vhep(2,put) = w.y * conv
      vhep(3,put) = w.z * conv
      vhep(4,put) = clight * path.time * conv

      ipvhep(put) = vtx_hep_n
      jmulti(put) = jmulti(hep)

      vtx_intrk(vtx_hep_n) = hep
      vtx_outrk(vtx_hep_n) = put
      vtx_ntrk(vtx_hep_n) = 1

      vtx_pos(1, vtx_hep_n) = w.x
      vtx_pos(2, vtx_hep_n) = w.y
      vtx_pos(3, vtx_hep_n) = w.z
      vtx_pos(4, vtx_hep_n) = clight * path.time

c     Normal exit
 1000 trk_brem_photon = 0
      return

c     Error exit
 9999 trk_brem_photon = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.5  1998/09/24 01:32:59  kutschke
c Set isthep to mark that the parent has brem'ed
c
c Revision 1.4  1998/09/17  00:30:38  kutschke
c Zero daughters of newly created particles.
c
c Revision 1.3  1997/04/04  20:30:18  garren
c add rcs log line
c
