      subroutine trk_dump_hit(lun)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Dump the track hit information to Fortran unit "lun".
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "hit_track.inc"
#include "mcp_summary.inc"

c     Externals

c     Calling arguments
      integer lun

c     Local variables
      integer i, trace, dmax, w(5)
      DFLOAT dircos(3), pos(3), dtime, dmeas
      character form*200, ff(5)*6

      data w/10, 10, 10, 8, 8/
      data dmax/4/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(lun .eq. 0) return

      if (hit_trk_num .eq. 0) then
         write(lun,5010) mcp_all.event
 5010    format(/80('*')/t20,'No track hits in event',i8/80('*')/)
         return
      endif

      write(lun,5000) hit_trk_num, mcp_all.event
 5000 format(/80('*')/t20,'Track hit information for ',i5,
     *                    ' hits in event',i8/80('*')/)

      write(lun,5001)
      write(lun,5002)
 5001 format(1x,t17,'Position of Wire or Plane',t46,
     *       'Direction Cosines')
 5002 format(3x,'#',t7,'Trace', t17,'x',t27,'y',t37,'z',t44,
     *      'cos_x',t52,'cos_y',t60,'cos_z',t69,'Time',t77,'Meas')

      do i = 1, hit_trk_num

        trace = hit_trk(i).trace
        call ucopy(hit_trk(trace).dircos, dircos, 3*FLOAT_WORD)
        call ucopy(hit_trk(trace).pos, pos, 3*FLOAT_WORD)
        dtime = hit_trk(trace).dtime_exact
        dmeas = hit_trk(trace).dmeas_exact
        call format_float(pos(1),w(1), dmax, ff(1))
        call format_float(pos(2),w(2), dmax, ff(2))
        call format_float(pos(3),w(3), dmax, ff(3))
        call format_float(dtime, w(4), dmax, ff(4))
        call format_float(dmeas, w(5), dmax, ff(5))

        form = '(i4, i6,'//ff(1)//','//ff(2)//','//ff(3)//', 3f8.4,'
     *         //ff(4)//','//ff(5)//')'

        write(lun, form) i, trace, pos(1), pos(2), pos(3), 
     *        dircos, dtime, dmeas

      enddo


      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:20  garren
c add rcs log line
c


