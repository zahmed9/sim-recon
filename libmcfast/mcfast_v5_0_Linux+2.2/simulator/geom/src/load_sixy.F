      subroutine load_sixy

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Load information into the rectangular z silicon disk structures
c  from the older .db files.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "siz_rect.inc"

c     Externals
      integer  lenocc
      external lenocc

c     Local variables
      integer i, j, det, lyr, wfr, nsiz_rect, nsegm, d, l, w
      integer num_siz
      real xwid1, xwid2, ywid1, ywid2, eps

      data eps/-1.e-6/       !Tolerance for gaps exceeding size of wafer
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      num_siz   = siz_rect_num

      siz_rect_num = min(max_siz_rect, num_siz + n_obj_sixy)
      
      if (siz_rect_num .gt. num_siz) then
        write(mcp_llpt,5001) n_obj_sixy, n_obj_layersixy
 5001   format('Loading Si rectangular z planes....'/
     *         'Number of stations = ',i4,/
     *         'Number of layers   = ',i4/)
      else
        return
      endif

      do i=1,n_obj_sixy
        if(sixy(i).num .gt. max_siz_rect) then
          write(mcp_llpt,5002) sixy(i).num, max_siz_rect
          write(6,5002)        sixy(i).num, max_siz_rect
 5002     format('load_siz_rect: Value of siz_rect device = ',i3,
     &           ' Larger than max allowed of ',i3)
          stop
        endif

        nsiz_rect = min(max_siz_rect, sixy(i).num + num_siz)
        siz_rect_par(nsiz_rect).name =
     &              sixy(i).name(:lenocc(sixy(i).name))
        siz_rect_par(nsiz_rect).nlayer =
     &              min(max_siz_rect_lyr, sixy(i).nly)
        siz_rect_par(nsiz_rect).x = 0.
        siz_rect_par(nsiz_rect).y = 0.
        siz_rect_par(nsiz_rect).z = sixy(i).zpos
        siz_rect_par(nsiz_rect).nchan = 0
      enddo

      do i=1,n_obj_layersixy
        det = layersixy(i).det + num_siz
        lyr = layersixy(i).lyr
        wfr = 1
        call getmat(layersixy(i).mat,
     &                 siz_rect_par(det).lyr(lyr).wfr(wfr).material)

c     See if gaps are legal
        xwid1 =  layersixy(i).xmax - layersixy(i).xmax_gap
        xwid2 = -layersixy(i).xmin + layersixy(i).xmin_gap
        ywid1 =  layersixy(i).ymax - layersixy(i).ymax_gap
        ywid2 = -layersixy(i).ymin + layersixy(i).ymin_gap

        if(xwid1.lt.eps .or. xwid2.lt.eps .or.
     &     ywid1.lt.eps .or. ywid2.lt.eps) then
          write(mcp_llpt,5010) det, lyr, wfr
 5010     format('LOAD_SIZ_RECT: Illegal gap size in device', i3,
     &           ' Layer',i4,' Wafer',i4)
          goto 8000
        endif

        siz_rect_par(det).lyr(lyr).xGapMinLocal = 
     &                    layersixy(i).xmin_gap
        siz_rect_par(det).lyr(lyr).xGapMaxLocal = 
     &                    layersixy(i).xmax_gap
        siz_rect_par(det).lyr(lyr).yGapMinLocal = 
     &                    layersixy(i).ymin_gap
        siz_rect_par(det).lyr(lyr).yGapMaxLocal = 
     &                    layersixy(i).ymax_gap

        nsegm = (layersixy(i).xmax - layersixy(i).coord0_x) / 
     &               layersixy(i).pitch_x
        if (nsegm .gt. layersixy(i).nsegm_x) then
          write(mcp_llpt,6000) det, lyr, wfr, layersixy(i).nsegm_x
          write(6,6000) det, lyr, wfr, layersixy(i).nsegm_x
 6000     format(' SIZ_RECT:', i4, ' Layer:', i4, ' Wafer:' i4 /,
     &      ' Max strip number along x-axis can not exceed ',i6/
     &      ' Quitting....')
          stop
        end if

        nsegm = (layersixy(i).ymax - layersixy(i).coord0_y) / 
     &               layersixy(i).pitch_y
        if (nsegm .gt. layersixy(i).nsegm_y) then
          write(mcp_llpt,6001) det, lyr, wfr, layersixy(i).nsegm_y
          write(6,6001) det, lyr, wfr, layersixy(i).nsegm_y
 6001     format(' SIZ_RECT:', i4, ' Layer:', i4, ' Wafer:' i4 /,
     &      ' Max strip number along y-axis can not exceed ',i6/
     &      ' Quitting....')
          stop
        end if
c        
        d = det
        l = lyr
        w = wfr
        siz_rect_par(d).lyr(l).wfr(w).type     = layersixy(i).type
        siz_rect_par(d).lyr(l).wfr(w).eff_hit  = layersixy(i).eff_hit
        siz_rect_par(d).lyr(l).wfr(w).stereo   = layersixy(i).stereo

        siz_rect_par(d).lyr(l).wfr(w).nsegm_x  = layersixy(i).nsegm_x
        siz_rect_par(d).lyr(l).wfr(w).pitch_x  = layersixy(i).pitch_x
        siz_rect_par(d).lyr(l).wfr(w).coord0_x = layersixy(i).coord0_x
        siz_rect_par(d).lyr(l).wfr(w).siga_x   = layersixy(i).sigma_x

        siz_rect_par(d).lyr(l).wfr(w).nsegm_y  = layersixy(i).nsegm_y
        siz_rect_par(d).lyr(l).wfr(w).pitch_y  = layersixy(i).pitch_y
        siz_rect_par(d).lyr(l).wfr(w).coord0_y = layersixy(i).coord0_y
        siz_rect_par(d).lyr(l).wfr(w).siga_y   = layersixy(i).sigma_y
c         
        siz_rect_par(d).lyr(l).wfr(w).xLocal = 
     &           0.5 *(layersixy(i).xmin + layersixy(i).xmax)
        siz_rect_par(d).lyr(l).wfr(w).yLocal =
     &           0.5 *(layersixy(i).ymin + layersixy(i).ymax)
        siz_rect_par(d).lyr(l).wfr(w).z        = siz_rect_par(d).z
     &                        + layersixy(i).z_local

        siz_rect_par(d).lyr(l).wfr(w).xlen    = layersixy(i).xmax -
     &                    layersixy(i).xmin
        siz_rect_par(d).lyr(l).wfr(w).ylen    = layersixy(i).ymax -
     &                    layersixy(i).ymin
        siz_rect_par(d).lyr(l).wfr(w).zlen    = layersixy(i).thick

c     Total number of channels in wafer
        siz_rect_par(d).lyr(l).wfr(w).nchan    = 
     &            siz_rect_par(d).lyr(l).wfr(w).nsegm_x *
     &            siz_rect_par(d).lyr(l).wfr(w).nsegm_y

c     Total number of channels, wafers in layer and device
        siz_rect_par(d).lyr(l).nchan = siz_rect_par(d).lyr(l).nchan +
     +    siz_rect_par(d).lyr(l).wfr(w).nchan
        siz_rect_par(d).lyr(l).nwafer = siz_rect_par(d).lyr(l).nwafer+1

        siz_rect_par(d).nchan = siz_rect_par(d).nchan +
     +    siz_rect_par(d).lyr(l).wfr(w).nchan
        siz_rect_par(d).nwafer = siz_rect_par(d).nwafer + 1

 8000   continue

      enddo

      do i= num_siz+ 1,siz_rect_num
        if(siz_rect_par(i).nwafer .ne. 0) then
          write(mcp_llpt,5004) i,
     +      siz_rect_par(i).name(:lenocc(sizrect(nsiz_rect).name)),
     +      siz_rect_par(i).nlayer,
     +      siz_rect_par(i).nwafer,
     +      siz_rect_par(i).nchan,
     +      siz_rect_par(i).z
 5004     format('  Siz_rect ', i5,//,a10,'# layers = ',i4,/
     +          ' # wafers = ',i5, ' # channels = ',i7,
     +          ' z = ',f9.3)
        endif
      enddo

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.9  1999/03/26 17:24:54  mcbride
c allow sixy and siz_rect in same geom file
c
c Revision 1.8  1997/10/24  17:56:25  yarba_j
c update and minor bug fixes related to new pixel geometry
c
c Revision 1.7  1997/10/21  16:07:35  mcbride
c remove tilt
c
c Revision 1.6  1997/10/08  20:40:41  mcbride
c temporary fix to load_sixy.F
c
c Revision 1.5  1997/04/04  20:29:53  garren
c add rcs log line
c
