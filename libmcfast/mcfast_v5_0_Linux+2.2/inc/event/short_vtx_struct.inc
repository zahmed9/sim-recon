#ifndef SHORT_VERTEX_STRUCT
#define SHORT_VERTEX_STRUCT

c
c Definitions of vertex structure with room for only 10 tracks.
c This is appropriate for use with secondary vertices.  A longer
c version of the structure is available which is appropriate
c for primary vertices, which may have many more tracks.
c
c Not all information is necessarily filled in all cases. For
c example, if lcovar=.false. then vw is not defined.
c 
c There are three variables which are left as user dependent.
c Here is how they are defined within BTeV and within the mcfast
c examples area:
c
c  integer status                ! 0 = ok
c                                ! 1 = track list overflow
c                                !-1 = error from lower level routine
c  integer mode                  ! 1 = true vertex position
c                                ! 2 = perfect pattern recognition and 
c                                !     then a real fit.
c                                ! 3 = real pattern recognition and fit
c                                ! 4 = some other implementation of 3
c  integer ver                   ! Version number of the given mode.
c
c  The structure defines redundant information ( (pos,vp) is a subset of 
c  (w.vw) ).  However this is needed to have a nice match to the calling
c  arguments of kfit_build_vtx.
c

#include "const.inc"
#include "wtrack_struct.inc"

c      ! Maximum number of tracks in a short vertex.
      integer max_short_vtx_track
      parameter ( max_short_vtx_track = 10 )

c      ! Dimension of pos.
      integer m_pos_s
      parameter ( m_pos_s = 3 )

c      ! Dimension of vw.
      integer m_vw_s
      parameter ( m_vw_s = 7 )

      structure /short_vtx_struct/

         DFLOAT  pos(m_pos_s)          ! Vertex position
c                                       ! On calls to kfit_build_vtx this
c                                       ! is both an input and an output.
c                                       ! As an input it is the starting
c                                       ! value of the fit.

         DFLOAT  vp(m_pos_s,m_pos_s)   ! Covariance matrix of position

c                                       ! The next two items may or may not
c                                       ! be filled, depending on lcovar.

         record  /wtrack_struct/  w    ! Full wtrack of this vertex
c                                       ! (All DFLOATs so alignment is ok).

         DFLOAT  vw(m_vw_s,m_vw_s)     ! Covariance matrix of this wtrack

         DFLOAT  chisq                 ! Chisquared of the fit.
         DFLOAT  prob                  ! Probability of chi2 of the fit.

         integer status                ! 0 = ok
c                                       ! Other values are user dependent.
         integer mode                  ! User dependent.
         integer ver                   ! User dependent.
         integer ntrk                  ! Number of tracks in this vertex
         integer ndof                  ! Number of degres of freedom
c                                       ! = 2*ntrk-3
         integer track(max_short_vtx_track)
c                                       ! List of tracks in track_kine.inc
c                                       ! which participate in this vertex.
c
c                                       ! This is a record of information
c                                       ! passed to the fitter.  See fitter
c                                       ! code for details.
         integer update                ! Should tracks be updated after fit?
         integer ivopt(max_short_vtx_track)
c                                       ! Mark tracks as used in fit or not.
         logical lcovar                ! Is vw defined?
         integer dummy                 ! pad to align structure
      end structure

#endif
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:58:38  eugenio
c Initial revision
c
c Revision 1.4  2000/01/19 19:38:21  garren
c fix some ! comments which can cause problems for Linux user code
c
c Revision 1.3  1999/11/17  16:54:07  mcbride
c added pad to align structure
c
c Revision 1.2  1998/04/27  01:28:40  kutschke
c New file.
c
c
