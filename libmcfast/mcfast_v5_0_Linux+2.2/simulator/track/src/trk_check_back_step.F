      logical function trk_check_back_step ( w, s3d, dev, lyr  )
c
c Check that trk_find_bsil_plane does not move too far backwards.
c This is a hack: trk_find_bsil_plane needs to be rewritten properly.
c
c In central tracking, the treatment of barrel silcon wafers is as follows:
c 1) Trace the track to its intersection with the nominal radius of a
c    silicon layer, where the nominal radius is rpln_par(ipln).radius.
c 2) Then trk_find_bsil_plane is called to determine which wafer(s) in the
c    layer are intersected by the trajectory.
c 3) The step from the nominal radius to the actual intercept with the
c    wafer is a "small" step that can either be positive or negative.
c 4) When the production vertex of a track is near a silicon layer ( ie
c    for the daughter of a decay in flight ), or when a track is reaching
c    its curl point near a silicon layer, then the algorithm 
c    occaisionally fails.  The failures are characterized by large negative
c    step lengths.
c
c In this routine we test to see if the step exceeds the maximum allowed 
c backwards step.  The test is implemented as follows:
c
c 1) Draw a radial line from the origin to the point on the wafer.
c 2) Treat the arc s3d as a straight line.
c 3) Project the arc, s3d, onto the radial line defined in 1).
c    If a track has large eta and is almost parallel to the wafer,
c    then an s3d of order 1m, can result in a projection of 1 mm.
c 4) Limit the size of the projection computed in 3 to half of the 
c    radial space occupied by the wafer, typcially a few mm.
c    ( Include a small fudge factor for numerical precision. )
c
c This algorithm works well so long as the track is heading outwards
c ( increasing radius ) as it crosses the plane. If the track is heading
c inwards as it crosses the plane, then the plane will sometimes be missed
c

#include "wtrack_struct.inc"
#include "si_barrel.inc"

      ! Track paramaters at the intersection of the track with the wafer.
      record /wtrack_struct/ w

      ! 3D arc length from nominal radius of wafer to the point w.
      DFLOAT s3d

      ! Device and layer number.
      integer dev, lyr

      ! Maximum radial step size from nominal radius to end points of
      ! the wafer.
      DFLOAT delta_r

      ! Projection of arc onto the plane z=0.
      DFLOAT s2d
      DFLOAT sinth

      ! Cosine of 2-D angle between momentum and radius to wafer center.
      ! The projection of the arc length onto the radial line is: 
      ! s2d*abs(dot)
      DFLOAT dot


      ! A fudge factor.  There are certain pathological cases 
      ! in which some moderately large back steps are allowed.
      DFLOAT fudge
      parameter  ( fudge = 4.0 )

      ! Treat the trival case.
      trk_check_back_step = .true.
      if ( s3d .gt. 0. ) return

      if ( w.p .ne. 0. ) then
         sinth = w.pt/w.p
      else
         sinth = 1.
      endif
      s2d = s3d*sinth
      dot = (w.px*w.x + w.py*w.y) / sqrt(w.px**2+w.py**2) /
     *       sqrt(w.x**2+w.y**2)

      delta_r = 0.5 *( sib_par(dev).lyr(lyr).plane(1).delta_max -
     *                 sib_par(dev).lyr(lyr).plane(1).delta_min )

      if ( s2d*abs(dot) .lt. -fudge*delta_r ) 
     *     trk_check_back_step = .false.

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:18  garren
c add rcs log line
c
