      integer function fctl_get_recon_ctk(itrk, xref, c)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Return the c track parameters of reconstructed track "itrk"
c   relative to the indicated reference point.
c
c  itrk     integer variable (read)
c           Track number in recon list
c
c  xref(3)  DFLOAT array (read)
c           (x,y,z) of reference point
c
c *c        c track structure (write)
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
#include "ctrack_struct.inc"
#include "bfield_struct.inc"

c     Externals
      integer  cvt_wtk_ctk, move_ctk_point
      external cvt_wtk_ctk, move_ctk_point

c     Calling arguments
      integer itrk
      DFLOAT xref(3)
      record /ctrack_struct/ c

c     Local variables
      integer itrk_c, status
      record /wtrack_struct/ w
      record /bfield_struct/ bf
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(itrk.le.0 .or. itrk.gt.trk_off_num) goto 9999

c     Convert to c form at reference point.
      call get_bfield(xref, bf)
      call ucopy(trk_off(itrk), w, WTRACK_WORD)
      status = cvt_wtk_ctk(w, xref, bf, c)

      fctl_get_recon_ctk = 0
      return

c     Error ... track does not exist
 9999 fctl_get_recon_ctk = 1
      call vzero(c, CTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:15  eugenio
c Initial revision
c
c Revision 1.3  1998/06/23 22:41:47  bphyslib
c rename routines moved from track to fitters library
c
c Revision 1.2  1997/04/04  20:30:24  garren
c add rcs log line
c
