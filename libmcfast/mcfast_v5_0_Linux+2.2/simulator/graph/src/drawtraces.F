      subroutine drawtraces
************************************************************************
*
*       drawtraces
*
*       MCFAST Geomview graphics
*
*       Draw traces from track propagation
*
************************************************************************
      implicit none
#include "stdhep.inc"
#include "trace.inc"
#include "det_draw.inc"
#include "det_structure.inc"
#include "det_att_structure.inc"
      integer lun, i, j, itk, ntk, npt, nsofar
      logical active_track
      record /color_s/ col
*
*------------------------------------------------------------------------
*
      if (.not.geomview_out) return

      lun = lungraph
*
***     are there traces?
      if (trace_num .eq. 0) then
        print *,'No traces, no trace graphics'
      endif
*
      write(lun,'(a)') 'appearance {'
      write(lun,'(a)') 'linewidth 3'
      write(lun,'(a)') 'material { ka .7 }'
      write(lun,'(a)') '} # end appearance'
      write(lun,*) 'LIST'
      do itk=1,nhep   ! loop over HEPEVT particles
        active_track = .false.
        nsofar = 0
        do i=1, trace_num       ! find trace points for this track
          if (trace_par(i).hep.eq.itk) then
            if (.not.active_track) then
              npt = 0
              do j=1, trace_num ! find trace points for this track
                if (trace_par(j).hep.eq.itk) npt=npt+1
              enddo
              active_track = .true.
              write(lun,*) 'VECT'
              write(lun,*) 1,npt,1 ! nline nvert ncolor
              write(lun,*) npt  ! no. of vertices in polyline 1
              write(lun,*) 1    ! no. of colors in polyline 1
            endif
            write(lun,*) trace_par(i).w.x,trace_par(i).w.y,
     +        trace_par(i).w.z
            nsofar = nsofar +1
            if (nsofar.eq.npt) then
              call colortrk(trace_par(i).type,trace_par(i).hep,col)
              write(lun,*) col.r, col.g, col.b, 1.  ! color for polyline 1
            endif
          endif
        enddo
      enddo
*
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:58  garren
c add rcs log line
c
