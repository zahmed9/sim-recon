      subroutine trk_dump_vtxhep(lun)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Dump the vertex information to Fortran unit "lun".
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "stdhep.inc"
#include "vtxhep.inc"

c     Externals

c     Calling arguments
      integer lun

c     Local variables
      integer i, j, dmaxv, w(4)
      DFLOAT time
      character form*200, ff(4)*6

      data dmaxv/4/
      data w/ 10, 10, 10, 10/ !Floating point column widths
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(lun .eq. 0) return

      if (vtx_hep_n .eq. 0) then
         write(lun,5010) nevhep
 5010    format(/80('*')/t20,'No vertex information in event',
     *          i8/80('*')/)
         return
      endif

      write(lun,5000) vtx_hep_n, nevhep
 5000 format(/80('*')/t18,'Vertex information for',i5,' vertices '
     *       ' in event',i8/80('*')/)

      write(lun,5001)
      write(lun,5002)
 5001 format(1x, t9,'Vertex-Info', t25, 'Track #', t35, 
     *       '#Tracks', t47, 'Vertex Position in cm')

 5002 format(3x,'#',t8,'Product',t16,'Decay', t22,'Incmng',t29,
     *      'Outgng',t36, 'Emrgng', t46, 'x', t56, 'y', t66, 'z'
     *       t74,'c*Time')

      do i = 1, vtx_hep_n

c     Format the values for the given column width w(i)
        call format_float(vtx_pos(1,i), w(1), dmaxv, ff(1))
        call format_float(vtx_pos(2,i), w(2), dmaxv, ff(2))
        call format_float(vtx_pos(3,i), w(3), dmaxv, ff(3))
        call format_float(vtx_pos(4,i), w(4), dmaxv, ff(4))

        form = '(i4, 5i7,'//ff(1)//','//ff(2)//','//ff(3)//','
     *         //ff(4)//')'

        write(lun, form) i, ipvhep(i), idvhep(i), vtx_intrk(i),
     *                 vtx_outrk(i), vtx_ntrk(i), (vtx_pos(j,i), j=1,4)


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

