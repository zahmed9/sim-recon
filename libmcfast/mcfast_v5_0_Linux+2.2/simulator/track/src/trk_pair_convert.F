      integer function trk_pair_convert(hep, w, path)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Converts a gamma to e+e-
c
c  Inputs:
c  hep       integer variable
c            Position of particle in HEPEVT list
c
c  w         w track structure
c            Track parameters in w format
c
c  path      path structure
c            Path information
c
c  Return:
c            0 if all OK
c            1 if HEPEVT list too large
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "path_struct.inc"
#include "stdhep.inc"
#include "vtxhep.inc"

c     Externals
      real     rann
      external rann

c     Calling arguments
      integer hep
      record /wtrack_struct/ w
      record /path_struct/ path

c     Local variable
      integer id(2), put1, put2
      DFLOAT p4(5,2), p1, p2, ratio, mass, conv

      save id
      data id/-11, 11/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Room enough in HEPEVT list
      if(nhep+2 .gt. nmxhep) goto 9999

c     Room enough in vtxhep list
      if(vtx_hep_n .ge. maxvtx) goto 9999

c     Uniform distribution of momentum to e+ and e-
      p1 = w.p * rann(0)
      p2 = w.p - p1

      mass = 0.000511

      put1 = nhep + 1
      ratio = p1 / w.p

      phep(1,put1) = w.px * ratio
      phep(2,put1) = w.py * ratio
      phep(3,put1) = w.pz * ratio
      phep(4,put1) = sqrt(phep(1,put1)**2 + phep(2,put1)**2
     *                  + phep(3,put1)**2 + mass**2)
      phep(5,put1) = mass

      put2 = nhep + 2
      ratio = p2 / w.p

      phep(1,put2) = w.px - phep(1,put1)
      phep(2,put2) = w.py - phep(2,put1) 
      phep(3,put2) = w.pz - phep(3,put1)
      phep(4,put2) = sqrt(phep(1,put2)**2 + phep(2,put2)**2
     *                  + phep(3,put2)**2 + mass**2)
      phep(5,put2) = mass

c     Set mothers and daughters
      jdahep(1,hep) = put1
      jdahep(2,hep) = put2
      jmohep(1,put1) = hep
      jmohep(2,put1) = 0
      jmohep(1,put2) = hep
      jmohep(2,put2) = 0
      jdahep(1,put1) = 0
      jdahep(2,put1) = 0
      jdahep(1,put2) = 0
      jdahep(2,put2) = 0

c     Status and particle IDs
      isthep(hep)  = ISTHEP_PAIR
      isthep(put1) = 1
      isthep(put2) = 1
      idhep(put1) = id(1)
      idhep(put2) = id(2)

c     Vertex information
      vtx_hep_n = vtx_hep_n + 1

c     Store in mm
      conv = 1000. / unit_meter
      vhep(1,put1) = w.x * conv
      vhep(2,put1) = w.y * conv
      vhep(3,put1) = w.z * conv
      vhep(4,put1) = clight * path.time * conv

      vhep(1,put2) = vhep(1,put1)
      vhep(2,put2) = vhep(2,put1)
      vhep(3,put2) = vhep(3,put1)
      vhep(4,put2) = vhep(4,put1)

      ipvhep(put1) = vtx_hep_n
      ipvhep(put2) = vtx_hep_n
      idvhep(hep)  = vtx_hep_n
      jmulti(put1) = jmulti(hep)
      jmulti(put2) = jmulti(hep)

      vtx_intrk(vtx_hep_n) = hep
      vtx_outrk(vtx_hep_n) = put1
      vtx_ntrk(vtx_hep_n) = 2

      vtx_pos(1, vtx_hep_n) = w.x
      vtx_pos(2, vtx_hep_n) = w.y
      vtx_pos(3, vtx_hep_n) = w.z
      vtx_pos(4, vtx_hep_n) = clight * path.time

      nhep = nhep + 2

c     Normal exit
 1000 trk_pair_convert = 0
      return

c     Error exit
 9999 trk_pair_convert = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.5  1998/09/24 01:43:14  kutschke
c Mark parent isthep as pair converted.
c
c Revision 1.4  1998/09/17  00:31:18  kutschke
c Zero daughters of newly created particles.
c
c Revision 1.3  1997/04/04  20:30:31  garren
c add rcs log line
c
