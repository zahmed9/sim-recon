      subroutine print_tracelist(hep, nhits )

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  print out trace list

c  Inputs:
c  hep        integer variable
c             Hep track number
c
c  Outputs:
c
c  Return:
c             0 ==> all OK
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "stdhep.inc"
#include "hep_point.inc"
#include "hep_trace.inc"
#include "prim_vertex.inc"
#include "trace.inc"
#include "trace_types.inc"
#include "offline_track.inc"
#include "track_forward.inc"
#include "track_minhit.inc"
#include "rplane.inc"
#include "zplane.inc"
C
C     Externals
      character c_trace_type*32, c_plane_type*15

c     Calling arguments
      integer hep, nhits

c     Local variables
      integer nhit, hit, i, num_trace, last, first, next, status
      integer type, plane, dummy
      logical init

      integer ndets
      parameter( ndets=20 )
      integer det_hit(-1:ndets)

      record /bfield_struct/ bf
      record /wtrack_struct/ w, w_out
      record /ftrack_struct/ f, f_out, f_gen

      integer itype
      character*(40) cname

      data init/.TRUE./, dummy/0/
      save init, dummy
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(init) then
        init = .FALSE.
        OPEN( UNIT=15, FILE='tracelist.dat', STATUS='UNKNOWN' )
      endif

c     Get # of intersections and position of first one
      num_trace   = hep_trace(hep).ntrace
      first = hep_trace(hep).first_trace

c     Check min number of hits
      write( 15, * ) ' '
      write( 15, * ) 'Start: ', nevhep, hep, trk_off_num
      write( 15,  125 )
 125  format ( 6x, 'nevhep', '  hep', '    i', ' next', '  hit' ,
     +         ' type', '  plane type # and name', 2x, 
     +         ' z-Plane type and name', 
     +         16x, '     x    ', '     y    ', '     z    ',
     +         '  radl', '      dedx' )

      ! reset counters
      nhit = 0
      do i=-1,ndets
        det_hit( i ) = 0
      enddo

      ! loop over traces
      do i=1,num_trace
        next = i + first - 1
        if(trace_par(next).hit .gt. 0) nhit = nhit + 1
        hit = trace_par(next).hit !Hit # in hit list
        type = trace_par(next).type !1 (2) for radial (z) plane
        plane = trace_par(next).plane !Plane # in radial or z list
        if ( plane .gt. 0 .and. plane .le. zpln_max ) then
          if( type .eq. 1 ) then
            itype = rpln_par(plane).type
            cname = rpln_par(plane).name
          else if( type .eq. 2 ) then
            itype = zpln_par(plane).type
            cname = zpln_par(plane).name
          else
            itype = type
            cname = 'unknown plane type'
          endif
        else
          itype = -1
          cname = ' '
        endif
        
        ! keep track of detector hits
        if( trace_par(next).hit .gt. 0 ) then
          det_hit( itype ) = det_hit( itype ) + 1
        endif

        ! print out trace info
        write( 15,  124 ) 'Trace: ', nevhep, 
c  print dummy=0 instead to allow diffs!
c     +       hep, i, next, hit, type, plane,
     +       hep, dummy, dummy, hit, type, plane,
     +       c_trace_type(type), itype, cname,
     +       trace_par(next).w.x, trace_par(next).w.y,
     +       trace_par(next).w.z, trace_par(next).radl,
     +       trace_par(next).dedx
  124   format(a,3i4,i7,i5,2i4,1x,a20,1x,i4,1x,a30,1x,3f10.6,2e10.3)
c  124   format ( a, 7i5, 1x, a20, 1x, i4, 1x, a30, 1x, 3f10.4,2e10.3)
      enddo
      
c     Check min number of hits
      nhit = 0
      do i=1,num_trace
        next = i + first - 1
        if(trace_par(next).hit .gt. 0) nhit = nhit + 1
      enddo
      nhits = nhit
      write( 15, * ) '#of hits for hep=', hep, ', nhit=', nhit
      if(nhit.lt.trk_minhit.all .or. nhit.eq.0) then
        write( 15, * ) 'not enough hits for hep=', hep, 
     *                               ', minhit=', trk_minhit.all,
     *                                 ', nhit=', nhit
      endif
c
      
c     print number of hits per detector
      write( 15, * ) 'hits per detector'
      do i=-1,ndets
        write( 15,* ) 'det=', i, ', #hits=', det_hit( i )
      enddo

      return
      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:34  eugenio
cInitial revision
c
cRevision 1.8  1998/11/20 05:32:18  mkl
cmore verbose findFirstMedium with nicer return type; update index after volume exit
c
c Revision 1.7  1998/08/11  16:59:51  mkl
c print trace points to 6 digits precision
c
c Revision 1.6  1998/08/08  19:44:43  mkl
c return total number of hits in event
c
c Revision 1.5  1998/08/04  19:41:15  mkl
c print hits per detector
c
c Revision 1.4  1998/02/18  05:10:52  mkl
c printing of hits into tracelist file
c
c Revision 1.3  1998/02/17  22:53:40  mkl
c better handling of printing of unknown plane types
c
c Revision 1.2  1998/02/17  05:09:21  mkl
c added r-plane/z-plane handling for printout
c
c Revision 1.1  1998/02/16  21:30:28  mkl
c new printing routine to print tracelist
c
c
