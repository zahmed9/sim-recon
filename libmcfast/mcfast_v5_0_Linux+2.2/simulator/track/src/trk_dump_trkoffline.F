      subroutine trk_dump_trkoffline(lun)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Dump the offline track information to Fortran unit "lun".
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      implicit none

#include "const.inc"
#include "stdhep.inc"
#include "offline_track.inc"
#include "hit_track.inc"

c     Externals
      external  stdexpname
      character stdexpname*5

c     Calling arguments
      integer lun

c     Local variables
      integer i, j, hep, trace, dmax, nhit, nhit_sil
      integer nhit_stereo, w(8), off
      DFLOAT mass, err(7), chisq
      character name*5, form*200, ff(8)*6

      data dmax/4/
      data w/7*8, 11/ !Floating point column widths
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(lun .eq. 0) return

      if (trk_off_num .eq. 0) then
         write(lun,5010) nevhep
 5010    format(/103('*')/t30,'No offline track information in event'
     *         ,i8/103('*')/)
         return
      endif

      write(lun,5000) trk_off_num, nevhep
 5000 format(/103('*')/t23,'Offline track information for',i5,
     *       ' track(s) in event',i8/103('*')/)

      write(lun,5001)
      write(lun,5002)
 5001 format(1x, t6, 'Part',t17,'Trace',t23,'#of',t28,'Sil',t33,
     *      'Ster', t56, 'Measurement Errors')

 5002 format(3x,'#',t7,'ID',t13,'Hep#', t20,'#',t23, 'Hits',t28,
     *      'Hits',t33,'Hits', t40,'px', t48, 'py', t56, 'pz', t62,
     *       'Energy', t73,'x', t81, 'y', t89, 'z', t93, 'Chi Square')

      do i = 1, trk_off_num

c     Assign variables and format the covariance diagonal elements
         hep         = trk_off(i).hep
         name        = stdexpname(hep,5)
         nhit        = trk_off(i).nhit
         nhit_sil    = trk_off(i).nhit_sil
         nhit_stereo = trk_off(i).nhit_stereo
         chisq       = trk_off(i).chisq
         do j = 1, 7
            err(j)   = sqrt(abs(trk_off(i).cov(j,j)))
            call format_float(err(j), w(j), dmax, ff(j))
         enddo

c     Format the values for the given column width w(i)
         call format_float(chisq,  w(8), dmax, ff(8))

         form = '(i4, 1x, a5, 5i5,'//ff(1)//','//ff(2)//','//
     *           ff(3)//','//ff(4)//','//ff(5)//','//ff(6)//','//
     *           ff(7)//','//ff(8)//')'

         write(lun, form) i, name, hep, trace, nhit, nhit_sil,
     *                 nhit_stereo, (err(j), j=1,7), chisq

      enddo


      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:21  garren
c add rcs log line
c

