      subroutine klm_select_origin ( trace, pos )

c At the start of each step in the Kalman filter, one moves the track
c from the present coordinate system to a new one, associated with
c the new measurement or scattering surface.  In order to ensure 
c numerical precision, even with double precision, it is necessary
c to make this choice differently for different detector types.
c
c  1) If there is no associated measurement, only scattering and dE/dx, 
c     then the new origin must be a point on the scattering surface
c     in the neighbourhood of the point of intersection of the track with 
c     the surface.  The true point of intersection is a perfectly
c     good point to use; probably any point within a few mm is fine.
c  2) If the measurement is a silicon wafer/wedge/pixel, then the new origin 
c     must be a point on the wafer/wedge/pixel which is in the neighbourhood
c     of the point of intersection of the track with the wafer/wedge/pixel.
c     Again, anywhere within a few mm is fine.
c  3) If the measurement is an axial or stereo drift chamber wire, 
c     then the new origin is any point on the wire.
c  4) For other measurement types stop the program.  This is
c     a safety device to ensure that when new devices are added
c     the correct decisions are made.
c
c The important metric in this decision is that various dcalc
c routines, which make linear approximations, fall within their radius
c of convergence.
c
c Note that:
c trace_par(trace).w.x - the point on the track at the intersection of
c                        the track with the specified surface.
c                      - For an axial wire this is the point at which
c                        the track crosses the nominal radius of the
c                        wire - it is not the point of closest approach
c                        of the track to the wire.
c
c hit_trk(hit).pos     - describes
c                             a) a point on an axial or stereo wire.
c                        or   b) the local origin of a silicon wafer/wedge.
c                      - In both cases, these specify the origin from
c                        which the measurement is made.
c

#include "const.inc"
#include "devtype.inc"
#include "hit_track.inc"
#include "trace.inc"

c     Arguments.

      ! Input: Index into trace_par for this point.
      integer trace

      ! Ouput: 3 vector for use as new origin in next transport step.
      DFLOAT pos(3)

c     Local Variables.

      ! Device type.
      integer dev_type

      if ( trace_par(trace).hit .le. 0 .or.
     *     trace_par(trace).hit .gt. trace_max ) goto 1000

      dev_type = hit_trk(trace_par(trace).hit).chan.devtype

      if ( dev_type .eq. jdev_silbarrel  .or.
     *     dev_type .eq. jdev_sildisk    .or. 
     *     dev_type .eq. jdev_pixelplane .or.
     *     dev_type .eq. jdev_silplane        ) goto 1000

      if ( dev_type .eq. jdev_driftbarrel ) goto 2000

      print 900, dev_type
 900  format ( ' select_trans_ctk: Do not know how to deal with ',
     *         'hit type: ', i4 )
      stop

 1000 pos(1) = trace_par(trace).w.x
      pos(2) = trace_par(trace).w.y
      pos(3) = trace_par(trace).w.z
      return

 2000 pos(1) = hit_trk(trace_par(trace).hit).pos(1)
      pos(2) = hit_trk(trace_par(trace).hit).pos(2)
      pos(3) = hit_trk(trace_par(trace).hit).pos(3)

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:18  eugenio
c Initial revision
c
c Revision 1.2  2000/01/13 05:06:05  kutschke
c Check for jdev_silplane devices.
c
c Revision 1.1  1999/05/12  20:21:34  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c
