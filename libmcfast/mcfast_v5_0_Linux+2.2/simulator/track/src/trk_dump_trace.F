      subroutine trk_dump_trace(lun)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Dump the trace information for mcfast
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none


#include "const.inc"
#include "trace.inc"
#include "material.inc"
#include "stdhep.inc"

c     Externals

c     Calling arguments
      integer lun

c     Local variables
      integer i, j, type, hep, dmax, matindex, w(5)
      DFLOAT path, time, tau, radl, dedx, eta(3)
      character ctype(10)*9, material*7
      character form*200, ff(5)*6

      data ctype/'rplane', 'zplane', 'cone', 'prod', 'decay', 'pair',
     *           'absorb', 'emshower', 'hadshower', 'dummy'/
      data w/9, 9, 9, 10, 10/
      data dmax/4/
      
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(lun .eq. 0) return

      if (trace_num .eq. 0) then
         write(lun,4000) nevhep
         return
      end if
 4000 format(/103('*')/t25,'No Trace information in event',i7/103('*')/)
         
      write(lun,5000) trace_num, nevhep
 5000 format(/103('*')/t19,'Trace information for ',i5, 
     *       ' track intersections in event',i7/103('*')/)


      write(lun,5001)
      write(lun,5002)
 5001 format(1x, t23, 'Path', t32, 'Time', t41, 'Tau',
     *      t59, 'dE/dx', t75, 'Direction Cosines of Normal')
 5002 format(3x,'#',t7, 'Hep#', t12, 'Type', t23, '(cm)', t31, 
     *      '(nsec)', t40, '(nsec)', t47, 'Material',t59, '(Mev)', t69, 
     *      'Radl', t78'cos_x', t87, 'cos_y', t96, 'cos_z')
      do i=1,trace_num

        type     = trace_par(i).type
        hep      = trace_par(i).hep
        path     = trace_par(i).path
        time     = trace_par(i).time
        tau      = trace_par(i).tau
        matindex = trace_par(i).material
	if (matindex .ge. 1 .and. matindex .le. mtl_num) then
           material = mtl_par(matindex).name
        else
           material = '       '
	end if
        dedx     = trace_par(i).dedx*1000 !Convert to Mev
        radl     = trace_par(i).radl
        call ucopy(trace_par(i).eta, eta, 3*FLOAT_WORD)
        call format_float(path, w(1), dmax, ff(1))
        call format_float(time, w(2), dmax, ff(2))
        call format_float(tau,  w(3), dmax, ff(3))
        call format_float(dedx, w(4), dmax, ff(4))
        call format_float(radl, w(5), dmax, ff(5))

        form = '(i4, i5, x, a7, x,'//ff(1)//','//ff(2)//','//
     *  ff(3)//', x, a7,'//ff(4)//','//ff(5)//', 3f9.4)'

        if (type .eq. 4 .or. type .eq. 10) then
           write(lun,form) i, hep, ctype(type), path, time, tau
        else
           write(lun,form) i, hep, ctype(type), path, time, tau,
     *                     material, dedx, radl, eta
        end if
              

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
