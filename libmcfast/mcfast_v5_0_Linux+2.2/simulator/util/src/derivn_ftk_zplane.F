      integer function derivn_ftk_zplane(f1, f2, bf, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the forward parameters at a new z plane
c  wrt parameters at the old z plane in a dipole B field.
c
c  The derivative is calculated numerically.
c
c  f1       f track structure (read)
c           Track parameters at old z plane.
c
c  f2       f track structure (read)
c           Track parameters at new z plane.
c
c  bf       B field structure (read)
c           B field information
c
c *R        DFLOAT array (write)
c           5x5 derivative matrix of d(f2) / d(f1)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ftrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     Externals
      integer  move_ftk_zplane
      external move_ftk_zplane

c     calling arguments
      record /ftrack_struct/ f1, f2
      record /bfield_struct/ bf
      DFLOAT R(5,5)

c     local variables
      record /ftrack_struct/ fi, ff
      DFLOAT dalpha, dxslp, dyslp, dxp, dyp, psave, s3d
      integer status

      data dalpha /0.02/
      data dxslp /0.01/
      data dyslp /0.01/
      data dxp /0.1/
      data dyp /0.1/

      save dalpha, dxslp, dyslp, dxp, dyp
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Save initial track
      call ucopy(f1, fi, FTRACK_WORD)

      call vzero(R, 5*5*FLOAT_WORD)

c     Change each parameter in turn to calculate numerical derivative

      psave = fi.alpha
      fi.alpha = fi.alpha + dalpha
      status = move_ftk_zplane(fi, f2.zp, bf, ff, s3d)
      if(status .ne. 0) goto 9999
      R(jfalpha,jfalpha)  = (ff.alpha - f2.alpha) / dalpha
      R(jfyslp,jfalpha) = (ff.yslp - f2.yslp) / dalpha
      R(jfxslp,jfalpha)  = (ff.xslp - f2.xslp) / dalpha
      R(jfxp,jfalpha)  = (ff.xp - f2.xp) / dalpha
      R(jfyp,jfalpha)  = (ff.yp - f2.yp) / dalpha
      fi.alpha = psave

      psave = fi.yslp
      fi.yslp = fi.yslp + dyslp
      status = move_ftk_zplane(fi, f2.zp, bf, ff, s3d)
      if(status .ne. 0) goto 9999
      R(jfalpha,jfyslp)  = (ff.alpha - f2.alpha) / dyslp
      R(jfyslp,jfyslp) = (ff.yslp - f2.yslp) / dyslp
      R(jfxslp,jfyslp)  = (ff.xslp - f2.xslp) / dyslp
      R(jfxp,jfyslp)  = (ff.xp - f2.xp) / dyslp
      R(jfyp,jfyslp)  = (ff.yp - f2.yp) / dyslp
      fi.yslp = psave

      psave = fi.xslp
      fi.xslp = fi.xslp + dxslp
      status = move_ftk_zplane(fi, f2.zp, bf, ff, s3d)
      if(status .ne. 0) goto 9999
      R(jfalpha,jfxslp)  = (ff.alpha - f2.alpha) / dxslp
      R(jfyslp,jfxslp) = (ff.yslp - f2.yslp) / dxslp
      R(jfxslp,jfxslp)  = (ff.xslp - f2.xslp) / dxslp
      R(jfxp,jfxslp)  = (ff.xp - f2.xp) / dxslp
      R(jfyp,jfxslp)  = (ff.yp - f2.yp) / dxslp
      fi.xslp = psave

      psave = fi.xp
      fi.xp = fi.xp + dxp
      status = move_ftk_zplane(fi, f2.zp, bf, ff, s3d)
      if(status .ne. 0) goto 9999
      R(jfalpha,jfxp)  = (ff.alpha - f2.alpha) / dxp
      R(jfyslp,jfxp) = (ff.yslp - f2.yslp) / dxp
      R(jfxslp,jfxp)  = (ff.xslp - f2.xslp) / dxp
      R(jfxp,jfxp)  = (ff.xp - f2.xp) / dxp
      R(jfyp,jfxp)  = (ff.yp - f2.yp) / dxp
      fi.xp = psave

      psave = fi.yp
      fi.yp = fi.yp + dyp
      status = move_ftk_zplane(fi, f2.zp, bf, ff, s3d)
      if(status .ne. 0) goto 9999
      R(jfalpha,jfyp)  = (ff.alpha - f2.alpha) / dyp
      R(jfyslp,jfyp) = (ff.yslp - f2.yslp) / dyp
      R(jfxslp,jfyp)  = (ff.xslp - f2.xslp) / dyp
      R(jfxp,jfyp)  = (ff.xp - f2.xp) / dyp
      R(jfyp,jfyp)  = (ff.yp - f2.yp) / dyp
      fi.yp = psave

      derivn_ftk_zplane = 0
      return

c     Error return
9999  derivn_ftk_zplane = status
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:24  garren
c add rcs log line
c
