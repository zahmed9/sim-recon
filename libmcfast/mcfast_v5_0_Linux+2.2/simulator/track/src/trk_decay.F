      integer function trk_decay(hep, w, path)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Decays particle and adds daughters to end of the HEPEVT list.
c
c  Inputs:
c  hep       integer variable
c            Position of particle in HEPEVT list
c
c  w         w track structure
c            Track parameters
c
c  path      path structure
c            Path information
c
c Return
c            0 if no errors
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "path_struct.inc"
#include "mcp_summary.inc"
#include "qqpars.inc"
#include "mcgen.inc"
#include "qqbrat.inc"
#include "qqprop.inc"
#include "stdhep.inc"
#include "vtxhep.inc"

c     Externals
      integer  qqtran
      external qqtran

c     Calling arguments
      integer hep
      record /wtrack_struct/ w
      record /path_struct/ path

c     Local variables
      integer i, j, qq_pos, last, lastsv, channel, put, type
      integer qq_parent, hep_parent, ndau
      DFLOAT conv
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(hep .le. 0 .or. hep .ge. NMXHEP) goto 9998

c     Need to put parent in list because 2 body angular decay distributions
c     use the momentum vector of the particle in the rest frame of its
c     parent as the z axis.
      if(jmohep(1,hep) .gt. 0) then
        hep_parent = jmohep(1,hep)
        qq_parent = 1
        qq_pos = 2
        do i=1,5
          p(qq_parent,i) = phep(i,hep_parent)
        enddo
      else
        qq_parent = 0
        qq_pos = 1
      endif

      n = qq_pos
      last = qq_pos
      p(qq_pos,1) = w.px
      p(qq_pos,2) = w.py
      p(qq_pos,3) = w.pz
      p(qq_pos,4) = w.E
      p(qq_pos,5) = phep(5,hep)

      k(qq_pos,1) = -qq_parent                !Parent of this particle
      k(qq_pos,2) = qqtran(idhep(hep), 2)     !Particle type in QQ format
      if(k(qq_pos,2) .le. 0) goto 9999        !Make sure we recognize it

      lastsv = last
      channel  = 0
      type = k(qq_pos,2)

c     Decay unstable particle
      if(iplist(1,type) .ne. 0) then
        call qqdeca(qq_pos, last, channel)

        ndau = last - lastsv

c     Save vertex info
	if (vtx_hep_n .ge. maxvtx) goto 9997
        vtx_hep_n = vtx_hep_n + 1
        vtx_ntrk(vtx_hep_n) = ndau
        vtx_intrk(vtx_hep_n) = hep
        vtx_outrk(vtx_hep_n) = nhep + 1
        vtx_pos(1,vtx_hep_n) = w.x
        vtx_pos(2,vtx_hep_n) = w.y
        vtx_pos(3,vtx_hep_n) = w.z
        vtx_pos(4,vtx_hep_n) = clight * path.time

c     Save HEPEVT info
        conv = 1. / (0.001*unit_meter)   !Conversion to mm
        isthep(hep)   = 2
        jdahep(1,hep) = nhep + 1
        jdahep(2,hep) = nhep + ndau
        idvhep(hep) = vtx_hep_n
        do i=1,ndau
	  if (nhep .ge. NMXHEP) goto 9998
          nhep = nhep + 1
          put = qq_pos + i
          do j=1,5
            phep(j,nhep) = p(put,j)
          enddo
          do j=1,4
            vhep(j,nhep) = vtx_pos(j,vtx_hep_n) * conv
          enddo
          idhep(nhep) = qqtran(k(put,2), 1)
          isthep(nhep) = 1
          jmohep(1,nhep) = hep
          jmohep(2,nhep) = 0
          jdahep(1,nhep) = 0
          jdahep(2,nhep) = 0
          ipvhep(nhep) = idvhep(hep)
          jmulti(nhep) = jmulti(hep)
        enddo

      endif

c     Normal exit
 1000 trk_decay = 0
      return
      
c     Error exit-- overflow vertex array
 9997 trk_decay = 3
      write(6, 5001) vtx_hep_n, mcp_all.event
 5001 format('trk_decay: WARNING, truncating vertex list at ',
     &        i6,' for event ', i6)
      return
      
c     Error exit-- overflow hepevt block
 9998 trk_decay = 2
      write(6, 5002) nhep, mcp_all.event
 5002 format('trk_decay: WARNING, truncating hepevt list at ',
     &        i6,' for event ', i6)
      return
 
c     Error exit
 9999 trk_decay = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.6  1999/11/23 19:34:51  mcbride
c do not allow particles to overflow the list
c
c Revision 1.5  1998/09/24  01:41:55  kutschke
c Mark parent isthep as decayed.
c
c Revision 1.4  1998/09/17  00:31:59  kutschke
c Set jmulti for newly created particles.
c
c Revision 1.3  1997/04/04  20:30:19  garren
c add rcs log line
c
