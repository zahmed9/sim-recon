      subroutine trk_dump_stdhep(lun)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Dump the stdhep information to Fortran unit "lun".
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "stdhep.inc"
#include "vtxhep.inc"

c     Externals
      external  stdexpname
      character stdexpname*15

c     Calling arguments
      integer lun

c     Local variables
      integer i, j, dmaxp, dmaxm, dmaxv, w(6), ndau
      DFLOAT time
      character name*15, form*200, ff(6)*6

      data dmaxp, dmaxm, dmaxv/3, 4, 4/
      data w/10, 10, 10, 9, 8, 10/ !Floating point column widths
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(lun .eq. 0) return

      if (nhep .eq. 0) then
         write(lun,5010) nevhep
 5010    format(/118('*')/t39,'No stdhep information in event',
     *          i8/118('*')/)
         return
      endif

      write(lun,5000) nhep, nmulti, nevhep
 5000 format(/118('*')/t23,'Stdhep information for',i5,' particles '
     *       'with ',i5,' interaction(s) in event',i8/118('*')/)

      write(lun,5001)
      write(lun,5002)
 5001 format(1x, t35, '#', t39, '1st', t44, 'Mult', t55, 
     *      'Momentum in GeV/c',t95,'Vertex-Info')

 5002 format(3x,'#',t14,'ID',t22,'Stat', t27,'Parnt',t33,'Dautr',t39,
     *      'Dau',t43, 'Int #',t53'px',t63,'py',t73,'pz',t79,'Energy',
     *       t88,'Mass',t94,'Product',t103,'Decay',t111,'c*Time')

      do i = 1, nhep
        ndau = jdahep(2,i) - jdahep(1,i) + 1
        if (jdahep(1,i) .eq. 0) ndau = 0
        name = stdexpname(i,15)
        time = vhep(4,i)

c     Format the values for the given column width w(i)
        call format_float(phep(1,i), w(1), dmaxp, ff(1))
        call format_float(phep(2,i), w(2), dmaxp, ff(2))
        call format_float(phep(3,i), w(3), dmaxp, ff(3))
        call format_float(phep(4,i), w(4), dmaxp, ff(4))

        call format_float(phep(5,i), w(5), dmaxm, ff(5))

        call format_float(time, w(6), dmaxv, ff(6))

        form = '(i4, 1x, a15, i4, i6, 3i5,'//ff(1)//','//ff(2)//','//
     *           ff(3)//','//ff(4)//','//ff(5)//', i6, i7, x,'//
     *           ff(6)//')'

        write(lun, form) i, name, isthep(i), jmohep(1,i), ndau,
     *        jdahep(1,i), jmulti(i), (phep(j,i), j=1,5),
     *        ipvhep(i), idvhep(i), time

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


