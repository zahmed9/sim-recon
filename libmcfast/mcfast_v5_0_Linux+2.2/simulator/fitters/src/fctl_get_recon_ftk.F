      integer function fctl_get_recon_ftk(itrk, xref, f)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Return the f track parameters of reconstructed track "itrk"
c   relative to the indicated reference point.
c
c  itrk     integer variable (read)
c           Track number in recon list
c
c  xref(3)  DFLOAT array (read)
c           (x,y,z) of reference point
c
c *f        f track structure (write)
c           Track parameters returned to caller
c
c return    
c           0 ==> all OK
c           1 ==> track does not exist
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      save

#include "offline_track.inc"
#include "track_central.inc"
#include "wtrack_struct.inc"
#include "ftrack_struct.inc"
#include "bfield_struct.inc"

c     Externals
      integer  cvt_wtk_ftk, move_wtk_point
      external cvt_wtk_ftk, move_wtk_point

c     Calling arguments
      integer itrk
      DFLOAT xref(3)
      record /ftrack_struct/ f

c     Local variables
      integer status
      DFLOAT s3d
      record /wtrack_struct/ w
      record /bfield_struct/ bf
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(itrk.le.0 .or. itrk.gt.trk_off_num) goto 9999

c     Convert to f form at reference point.
      call get_bfield(xref, bf)
      status = move_wtk_point(trk_off(itrk).w, xref, bf, w, s3d)
      if (status .ne.0 ) goto 9998
      status = cvt_wtk_ftk(w, f)
      if (status .ne.0 ) goto 9998

      fctl_get_recon_ftk = 0
      return

c     Error in lower level routine.
 9998 fctl_get_recon_ftk = 1
      return

c     Error ... track does not exist
 9999 fctl_get_recon_ftk = 1
      call vzero(f, FTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:15  eugenio
c Initial revision
c
c Revision 1.4  1998/06/23 22:41:47  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.3  1997/04/04  20:30:25  garren
c add rcs log line
c
