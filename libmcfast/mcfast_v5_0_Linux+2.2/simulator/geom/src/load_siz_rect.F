      subroutine load_siz_rect

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Load information into the rectangular z silicon disk structures
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "siz_rect.inc"

c     Externals
      integer  lenocc
      external lenocc

c     Local variables
      integer i, j, det, lyr, wfr, wfrx, wfry, nsiz_rect, 
     *        nsegm, nsegmx, nsegmy,
     *        isegm, nWaferTotal,
     *        nXWfrBeforeGap, nYWfrBeforeGap 
      integer case
      integer index
      real offset, spaceX, spaceY, xCoveredWfr, yCoveredWfr, eps
      real gapx, gapy
      integer xdir, ydir
      real xlocal, ylocal 
      real wfr1X, wfr1Y
      integer imat
      record /layersizrect_s/ LayerIn
      record /wfrsizrect_s/ WaferIn
      record /siz_rect_wafer_struct/ WaferSave

      data eps/1.e-6/       !Tolerance for gaps exceeding size of wafer
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Need this in case siz_rect geometry was filled already by reading
c     in using older zsixy geometry definition
      if (siz_rect_num .gt. 0) return

      siz_rect_num = min(max_siz_rect, n_obj_sizrect)
      if (siz_rect_num .gt. 0) then
        write(mcp_llpt,5001) n_obj_sizrect, n_obj_layersizrect,
     *                       n_obj_wfrsizrect
 5001   format('Loading Si rectangular z planes....'/
     *         'Number of stations = ',i4,/
     *         'Number of layers   = ',i4,/
     *         'Number of wafers   = ',i4/)
      else
        return
      endif

      do i=1,siz_rect_num
        if(sizrect(i).num .gt. max_siz_rect) then
          write(mcp_llpt,5002) sizrect(i).num, max_siz_rect
          write(6,5002)        sizrect(i).num, max_siz_rect
 5002     format('load_siz_rect: Value of siz_rect device = ',i3,
     &           ' Larger than max allowed of ',i3)
          stop
        endif

        nsiz_rect = min(max_siz_rect, sizrect(i).num)
        siz_rect_par(nsiz_rect).name =
     &              sizrect(i).name(:lenocc(sizrect(i).name))
        siz_rect_par(nsiz_rect).nlayer =
     &              min(max_siz_rect_lyr, sizrect(i).nlayer)
        siz_rect_par(nsiz_rect).x = sizrect(i).xpos
        siz_rect_par(nsiz_rect).y = sizrect(i).ypos
        siz_rect_par(nsiz_rect).z = sizrect(i).zpos
        siz_rect_par(nsiz_rect).nchan = 0
      enddo

      do i=1,n_obj_layersizrect
       det = layersizrect(i).det
       lyr = layersizrect(i).lyr
       siz_rect_par(det).lyr(lyr).nwafer = 0
       siz_rect_par(det).lyr(lyr).nchan  = 0
       siz_rect_par(det).lyr(lyr).zCenter = 
     + layersizrect(i).zlayerlocal + siz_rect_par(det).z
       siz_rect_par(det).lyr(lyr).xCenter = siz_rect_par(det).x
       siz_rect_par(det).lyr(lyr).yCenter = siz_rect_par(det).y
       siz_rect_par(det).lyr(lyr).xGapMinLocal = 
     + -layersizrect(i).gapXlen / 2.
       siz_rect_par(det).lyr(lyr).xGapMaxLocal = 
     +  layersizrect(i).gapXlen / 2.
       siz_rect_par(det).lyr(lyr).yGapMinLocal = 
     + -layersizrect(i).gapYlen / 2.
       siz_rect_par(det).lyr(lyr).yGapMaxLocal = 
     +  layersizrect(i).gapYlen / 2.
       siz_rect_par(det).lyr(lyr).rotate = layersizrect(i).rotation
      enddo 

      do i=1,n_obj_wfrsizrect
        det  = wfrsizrect(i).det
        lyr  = wfrsizrect(i).lyr
cc        index = (det-1)*siz_rect_par(det).nlayer + lyr
cc temporary fix to find correct layer info - until we have better formula
	do j = 1,n_obj_layersizrect
	   if ( det .eq. layersizrect(j).det .and. 
     &          lyr .eq. layersizrect(j).lyr ) then
              index = j
	      goto 100
	   end if
	end do

c Make local copies of layer and 1st wafer 
c NOTE can't use ucopy everywhere because of problems with characters !
  100   call ucopy(layersizrect(index),LayerIn,n_el_layersizrect-1)
        layerIn.staggeringPattern = 
     &  layersizrect(index).staggeringPattern(
     &     :lenocc(layersizrect(index).staggeringPattern))

        waferIn.speci = wfrsizrect(i).speci(
     &     :lenocc(wfrsizrect(i).speci))
        waferIn.det = wfrsizrect(i).det
        waferIn.lyr = wfrsizrect(i).lyr
        waferIn.waferx = wfrsizrect(i).waferx
        waferIn.wafery = wfrsizrect(i).wafery
        waferIn.type = wfrsizrect(i).type
        waferIn.mat = wfrsizrect(i).mat(:lenocc(wfrsizrect(i).mat))
        waferIn.eff_hit = wfrsizrect(i).eff_hit
        waferIn.stereo = wfrsizrect(i).stereo
        waferIn.xlen = wfrsizrect(i).xlen
        waferIn.ylen = wfrsizrect(i).ylen
        waferIn.zlen = wfrsizrect(i).zlen
        waferIn.zoffset  = wfrsizrect(i).zoffset
        waferIn.nsegm_x  = wfrsizrect(i).nsegm_x
        waferIn.pitch_x  = wfrsizrect(i).pitch_x
        waferIn.coord0_x = wfrsizrect(i).coord0_x
        waferIn.sigma_x  = wfrsizrect(i).sigma_x
        waferIn.nsegm_y  = wfrsizrect(i).nsegm_y
        waferIn.pitch_y  = wfrsizrect(i).pitch_y
        waferIn.coord0_y = wfrsizrect(i).coord0_y
        waferIn.sigma_y  = wfrsizrect(i).sigma_y

c Estimate x- and y-area covered by wafers and see which case we deal with
c case=0 means NO GAP
c case=1 ---------------  case=2 ---------------  case=3 ---------------
c        |             |         |     | |     |         |             |
c        |             |         |     | |     |         |             |
c        |-------------|         |     | |     |         |  |-------|  |
c        |-------------|         |     | |     |         |  |-------|  |
c        |             |         |     | |     |         |             |
c        |             |         |     | |     |         |             |
c        ---------------         ---------------         ---------------

        case = 0
        xCoveredWfr = LayerIn.xlen 
        yCoveredWfr = LayerIn.ylen
        nXWfrBeforeGap = LayerIn.nWaferX/2
        nYWfrBeforeGap = LayerIn.nWaferY/2

        if (abs(LayerIn.gapxlen) .gt. eps .and.
     &      abs(LayerIn.gapylen) .gt. eps) then
         if (abs(LayerIn.xlen-LayerIn.gapxlen) .le. eps .and.
     &       abs(LayerIn.ylen-LayerIn.gapylen) .gt. eps) then
          case = 1
          xCoveredWfr = LayerIn.xlen
          yCoveredWfr = LayerIn.ylen - LayerIn.gapylen
         else if (abs(LayerIn.ylen-LayerIn.gapylen) .le. eps .and.
     &            abs(LayerIn.xlen-LayerIn.gapxlen) .gt. eps) then
          xCoveredWfr = LayerIn.xlen - LayerIn.gapxlen
          yCoveredWfr = LayerIn.ylen
          case = 2
         else
          case = 3
          xCoveredWfr = LayerIn.xlen-layerIn.gapxlen
          yCoveredWfr = LayerIn.ylen-layerIn.gapylen
          spaceX = LayerIn.xlen / LayerIn.nWaferX
          spaceY = LayerIn.ylen / LayerIn.nWaferY
          nXWfrBeforeGap = 
     &    int(0.5*(layerIn.xlen-layerIn.gapxlen)/spaceX + eps)
          nYWfrBeforeGap = 
     &    int(0.5*(layerIn.ylen-layerIn.gapylen)/spaceY + eps)
         end if
        end if

c We assume that 1st wafer be always put in the upper left corner (-x,+y)
c (sorry, we can NOT handle ANY order)
        wfr1X = -0.5*(LayerIn.xlen-waferIn.xlen)
        wfr1Y =  0.5*(LayerIn.ylen-waferIn.ylen)

c Find x- and y-spacing 
c In principal, may be larger or smaller than wafer size
c which will mean either dead areas or overlapping wafers
c but there maybe NO dead areas on borders of layers or 
c on borders of gaps in layers
        if (case .eq. 0 ) then
         spaceX = xCoveredWfr / LayerIn.nWaferX
         spaceY = yCoveredWfr / LayerIn.nWaferY
        else if (case .eq. 1) then
         spaceX = xCoveredWfr / LayerIn.nWaferX
         spaceY = (0.5*yCoveredWfr-waferIn.ylen) 
     &         / (layerIn.nwafery/2 - 1)
        else if (case .eq. 2) then
         spaceX = (0.5*xCoveredWfr-waferIn.xlen) 
     &          / (layerIn.nwaferx/2 - 1)
         spaceY = yCoveredWfr / LayerIn.nWaferY
        end if

c Special case=3 - check if gap has valid size;
c we only can handle this case with non-overlapping wafers;
c otherwise skip
        if (case .eq. 3) then
         if (abs(spaceX-WaferIn.xlen) .gt. eps .or.
     &       abs(spaceY-WaferIn.ylen) .gt. eps) then 
          write(6,5000) lyr, det
 5000     format('Can NOT put overlapping wafers around inner gap' /
     &           'skip layer ',i4,' of station ',i4)
          goto 2000
         end if
        end if

c We should also make sure that overlapping wafers 
c don't happen at the same z !!!
c NOTE : Here I reset some input data but I do it ONLY with local structures 
        if (spaceX.lt.waferIn.xlen .and.
     &      spaceY.lt.waferIn.ylen .and.
     &   layerIn.StaggeringPattern(1:2).ne.'CH') then
         layerIn.StaggeringPattern = 'CH'
        else if (spaceX.lt.waferIn.xlen .and.
     &   layerIn.StaggeringPattern(1:1).ne.'X' .and.
     &   layerIn.StaggeringPattern(1:2).ne.'CH') then
         layerIn.StaggeringPattern = 'X'
        else if (spaceY.lt.waferIn.xlen .and.
     &   layerIn.StaggeringPattern(1:1).ne.'Y' .and.
     &   layerIn.StaggeringPattern(1:2).ne.'CH') then
         layerIn.StaggeringPattern = 'Y'
        end if

c Ordering of wafers goes across, then down 
        xdir =  1
        ydir = -1

        if (WaferIn.speci(1:3) .eq. 'ALL' .or.
     +      WaferIn.speci(1:3) .eq. 'ONE'       ) then

c "Common" type wafer

         call getmat(waferIn.mat, imat)

         nWaferTotal = layerIn.nwaferx
     *               * layerIn.nwafery
         wfr = 0

c Loop over the # of wafers in the layers and set things
         do isegm=1,nWaferTotal

c First handle local position of each wafer in the layer
c and see if it falls into into active (xy) area or into a gap
          wfrx = mod((isegm-1),layerIn.nwaferx) + 1
          wfry = int((isegm-1)/layerIn.nwaferx) + 1

          if (case .eq. 0 .or. case .eq. 3) then
           xlocal = wfr1X + xdir*(wfrx-1)*spaceX
           ylocal = wfr1Y + ydir*(wfry-1)*spaceY
          else if (case .eq. 1) then
           xlocal = wfr1X + xdir*(wfrx-1)*spaceX
           if (wfry .le. nYWfrBeforeGap) then
            ylocal = wfr1Y + ydir*(wfry-1)*spaceY
           else
            yLocal = wfr1Y + ydir*(yCoveredWfr/2.+LayerIn.GapYLen
     &                            +(wfry-LayerIn.nWaferY/2-1)*spaceY)
           end if           
          else if (case .eq. 2) then
           ylocal = wfr1Y + ydir*(wfry-1)*spaceY
           if (wfrx .le. nXWfrBeforeGap) then
            xlocal = wfr1X + xdir*(wfrx-1)*spaceX
           else
            xLocal = wfr1X + xdir*(xCoveredWfr/2. + LayerIn.GapXLen
     &                            +(wfrx-LayerIn.nWaferX/2-1)*spaceX)
           end if           
          end if

c For case=3 - see if any part of wafer falls into gap
c         Is center of wafer in the gap.  If this is a layer made up
c         of a single wafer then skip this check.
          if (case .eq. 3 .and. WaferIn.speci(1:3) .ne. 'ONE' ) then
           if (abs(xlocal) .lt. layerIn.gapxlen/2.-eps .and.
     &         abs(ylocal) .lt. layerIn.gapylen/2.-eps) then
            goto 1000
           end if
c          Is upper left corner in the gap.
           if ( (abs(xlocal-waferIn.xlen/2.) .lt.
     &              layerIn.gapxlen/2.-eps) .and.
     &         (abs(ylocal+waferIn.ylen/2.) .lt.
     &              layerIn.gapylen/2.-eps)      ) then
               goto 1000
           endif
c          Is upper right  corner in the gap.
           if ( (abs(xlocal+waferIn.xlen/2.) .lt.
     &              layerIn.gapxlen/2.-eps) .and.
     &         (abs(ylocal+waferIn.ylen/2.) .lt.
     &              layerIn.gapylen/2.-eps)     ) then
               goto 1000
           endif
c          Is lower left corner in the gap.
           if ( (abs(xlocal-waferIn.xlen/2.) .lt.
     &              layerIn.gapxlen/2.-eps) .and.
     &         (abs(ylocal-waferIn.ylen/2.) .lt.
     &              layerIn.gapylen/2.-eps)      ) then
               goto 1000
           endif
c          Is lower right corner in the gap.
           if ( (abs(xlocal+waferIn.xlen/2.) .lt.
     &              layerIn.gapxlen/2.-eps) .and.
     &         (abs(ylocal-waferIn.ylen/2.) .lt.
     &              layerIn.gapylen/2.-eps)      ) then
               goto 1000
           endif

          end if

c Everything is OK; increment wfr
          wfr = wfr + 1

c Fill up structure
          waferSave.xLocal = xlocal
          waferSave.yLocal = ylocal

c Handle z-position
c There're 4 patterns for staggering wafers :
c 'X' means that all wafers in x-row are tiled
c 'Y' means that all wafers in y-column are tiled
c 'CH' (i.e. CHECKERED) means... checkered board ! 
c (in other words, if the 1st wafer in 1st x-row has a positive
c  z-offset relative to average z-position of layer, then the 1st
c  wafer in the 2nd x-row will have negative z-offset)
c 'NONE' means that all wafers are at the same z
          if (layerIn.StaggeringPattern(1:1) 
     &        .eq. 'X')then
           offset = (-1)**(wfrx-1) * waferIn.zoffset
          else if (layerIn.StaggeringPattern(1:1) 
     &             .eq. 'Y') then
           offset = (-1)**(wfry-1) * waferIn.zoffset
          else if (layerIn.StaggeringPattern(1:2) 
     &             .eq. 'CH') then
           offset = (-1)**(wfrx-1) * (-1)**(wfry-1) 
     &            * waferIn.zoffset
          else if (layerIn.StaggeringPattern(1:4) 
     &             .eq. 'NONE') then
           offset = waferIn.zoffset
          end if
          waferSave.z = offset + layerIn.zlayerlocal 
     &                + siz_rect_par(det).z

          waferSave.type = WaferIn.type
          waferSave.material = imat
          waferSave.eff_hit = WaferIn.eff_hit
          waferSave.stereo = WaferIn.stereo
          WaferSave.xlen = WaferIn.xlen
          WaferSave.ylen = WaferIn.ylen
          WaferSave.zlen = WaferIn.zlen

          nsegm = nint(0.5*(waferIn.xlen-waferIn.coord0_x)/
     +                 waferIn.pitch_x)
          if (nsegm .gt. waferIn.nsegm_x) then
            write(mcp_llpt,6000) det, lyr, wfr, waferIn.nsegm_x
 6000       format(' SIZ_RECT:', i4, ' Layer:', i4, ' Wafer:' i4 /,
     &        ' Max strip number along x-axis can not exceed ',i6/
     &        ' Quitting....')
            stop
          end if

          waferSave.nsegm_x  = waferIn.nsegm_x
          waferSave.pitch_x  = waferIn.pitch_x
          waferSave.coord0_x = waferIn.coord0_x
          waferSave.siga_x   = waferIn.sigma_x

          nsegm =nint(0.5*(waferIn.ylen-waferIn.coord0_y)/
     +                waferIn.pitch_y)
          if (nsegm .gt. waferIn.nsegm_y) then
            write(mcp_llpt,6001) det, lyr, wfr, waferIn.nsegm_y
 6001       format(' SIZ_RECT:', i4, ' Layer:', i4, ' Wafer:' i4 /,
     &        ' Max strip number along y-axis can not exceed ',i6/
     &        ' Quitting....')
            stop
          end if

          waferSave.nsegm_y  = waferIn.nsegm_y
          waferSave.pitch_y  = waferIn.pitch_y
          waferSave.coord0_y = waferIn.coord0_y
          waferSave.siga_y   = waferIn.sigma_y

c Total number of channels in wafer
          WaferSave.nchan = WaferSave.nsegm_x * WaferSave.nsegm_y

c Now copy over info for a given wafer into siz_rect structure
          call ucopy(waferSave,
     &               siz_rect_par(det).lyr(lyr).wfr(wfr), 19)

c Update # of wafers in the layer
          siz_rect_par(det).lyr(lyr).nwafer = 
     &    siz_rect_par(det).lyr(lyr).nwafer + 1

c Update # of channels in layer and device
          siz_rect_par(det).lyr(lyr).nchan = 
     +    siz_rect_par(det).lyr(lyr).nchan +
     +    siz_rect_par(det).lyr(lyr).wfr(wfr).nchan
          siz_rect_par(det).nchan = siz_rect_par(det).nchan +
     +    siz_rect_par(det).lyr(lyr).wfr(wfr).nchan

 1000    end do
         
        else if (WaferIn.speci(1:3) .eq. 'SPC' ) then

c "SPeCific" wafer
         wfrx = WaferIn.waferX
         wfry = WaferIn.waferY

c Handle x and y; see if it fits into active area or falls into gap (case=3)
c (in layer's ref.frame)
          if (case .eq. 0 .or. case .eq. 3) then
           xlocal = wfr1X + xdir*(wfrx-1)*spaceX
           ylocal = wfr1Y + ydir*(wfry-1)*spaceY
          else if (case .eq. 1) then
           xlocal = wfr1X + xdir*(wfrx-1)*spaceX
           if (wfry .le. nYWfrBeforeGap) then
            ylocal = wfr1Y + ydir*(wfry-1)*spaceY
           else
            yLocal = wfr1Y + ydir*(yCoveredWfr/2.+LayerIn.GapYLen
     &                            +(wfry-LayerIn.nWaferY/2-1)*spaceY)
           end if           
          else if (case .eq. 2) then
           ylocal = wfr1Y + ydir*(wfry-1)*spaceY
           if (wfrx .le. nXWfrBeforeGap) then
            xlocal = wfr1X + xdir*(wfrx-1)*spaceX
           else
            xLocal = wfr1X + xdir*(xCoveredWfr/2. + LayerIn.GapXLen
     &                            +(wfrx-LayerIn.nWaferX/2-1)*spaceX)
           end if           
          end if

c For case=3 - see if any part of wafer falls into gap
c First, check center of wafer
          if (case .eq. 3) then
           if (abs(xlocal) .lt. layerIn.gapxlen/2. .and.
     &         abs(ylocal) .lt. layerIn.gapylen/2.) then
c Yes, it falls into gap; skip it !
            goto 2000
           end if
c Now check if edges are OK
           if (abs(ylocal+ydir*(waferIn.ylen/2.-eps)) .lt.
     &         layerIn.gapylen/2. .or.
     &         abs(ylocal-ydir*(waferIn.ylen/2.-eps)) .lt.
     &         layerIn.gapylen/2. .or.
     &         abs(xlocal+xdir*(waferIn.xlen/2.-eps)) .lt.
     &         layerIn.gapxlen/2. .or.
     &         abs(xlocal-xdir*(waferIn.xlen/2.-eps)) .lt.
     &         layerIn.gapxlen/2.) then
c Yes, some edge interfer with gap; skip it
            goto 2000
           end if
          end if

c Everything's OK; find wafer's id
         wfr  = (wfrY-1)*layerIn.nwaferX + wfrX
         if (case .eq. 3) then
          if (wfry .gt. nYWfrBeforeGap .and.
     &        .not.(wfry .eq. (nYWfrBeforeGap+1) .and. 
     &              wfrx .le. nXWfrBeforeGap)) then
           wfr = wfr - ((wfry-nYWfrBeforeGap)
     &                 *(layerIn.nwaferx-2*nXWfrBeforeGap))
          end if
         end if

         waferSave.xLocal = xlocal
         waferSave.yLocal = ylocal

c Handle z-position
         waferSave.z = WaferIn.zoffset + layerIn.zlayerlocal
     &               + siz_rect_par(det).z

         waferSave.type = WaferIn.type
         call getmat(waferIn.mat,imat)
         waferSave.material = imat
         waferSave.eff_hit = WaferIn.eff_hit
         waferSave.stereo = WaferIn.stereo
         waferSave.xlen = waferIn.xlen
         waferSave.ylen = waferIn.ylen
         waferSave.zlen = waferIn.zlen

c Clear out "type-ALL" information to account later for this specific wafer
         siz_rect_par(det).lyr(lyr).nchan = 
     +   siz_rect_par(det).lyr(lyr).nchan -
     +   siz_rect_par(det).lyr(lyr).wfr(wfr).nchan
         siz_rect_par(det).nchan = siz_rect_par(det).nchan -
     +   siz_rect_par(det).lyr(lyr).wfr(wfr).nchan

         nsegm =nint(0.5*(waferIn.xlen-waferIn.coord0_x)/
     +               waferIn.pitch_x)
         if (nsegm .gt. waferIn.nsegm_x) then
            write(mcp_llpt,6010) det, lyr, wfr, waferIn.nsegm_x
 6010       format(' SIZ_RECT:', i4, ' Layer:', i4, ' Wafer:' i4 /,
     &        ' Max strip number along x-axis can not exceed ',i6/
     &        ' Quitting....')
            stop
         end if

         WaferSave.nsegm_x  = WaferIn.nsegm_x
         WaferSave.pitch_x  = WaferIn.pitch_x
         WaferSave.coord0_x = WaferIn.coord0_x
         WaferSave.siga_x   = WaferIn.sigma_x

         nsegm =nint(0.5*(WaferIn.ylen-WaferIn.coord0_y)/
     +               WaferIn.pitch_y)
         if (nsegm .gt. waferIn.nsegm_y) then
            write(mcp_llpt,6011) det, lyr, wfr, waferIn.nsegm_y
 6011       format(' SIZ_RECT:', i4, ' Layer:', i4, ' Wafer:' i4 /,
     &        ' Max strip number along y-axis can not exceed ',i6/
     &        ' Quitting....')
            stop
         end if

         WaferSave.nsegm_y  = WaferIn.nsegm_y
         WaferSave.pitch_y  = WaferIn.pitch_y
         WaferSave.coord0_y = WaferIn.coord0_y
         WaferSave.siga_y   = WaferIn.sigma_y

c Total number of channels in wafer
         WaferSave.nchan  = WaferSave.nsegm_x * WaferSave.nsegm_y

c Now copy over the wafer into siz_rect structure
         call ucopy(WaferSave,
     &              siz_rect_par(det).lyr(lyr).wfr(wfr), 19)

c Total number of channels in layer and device
         siz_rect_par(det).lyr(lyr).nchan = 
     +   siz_rect_par(det).lyr(lyr).nchan +
     +   siz_rect_par(det).lyr(lyr).wfr(wfr).nchan

         siz_rect_par(det).nchan = siz_rect_par(det).nchan +
     +   siz_rect_par(det).lyr(lyr).wfr(wfr).nchan

        end if

 2000 enddo

      do i=1,siz_rect_num
        if(siz_rect_par(i).nwafer .ne. 0) then
          write(mcp_llpt,5004)
     +      siz_rect_par(i).name(:lenocc(sizrect(nsiz_rect).name)),
     +      siz_rect_par(i).nlayer,
     +      siz_rect_par(i).nwafer,
     +      siz_rect_par(i).nchan,
     +      siz_rect_par(i).z
 5004     format('  Siz_rect',//,a10,'# layers = ',i4,/
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
c Revision 1.18  2000/01/28 02:53:01  kutschke
c Implement SPECI=1. Fix nsegm check - factor of 0.5 in wrong place.
c
c Revision 1.17  1999/03/26  17:25:30  mcbride
c fix print statement
c
c Revision 1.16  1999/03/16  23:47:18  kutschke
c Fix several bugs in case 3.
c
c Revision 1.15  1998/11/11  17:23:01  yarba_j
c fixed backward refference to layer for defining wafers
c
c Revision 1.14  1997/11/13  00:26:14  yarba_j
c fixed bug - stereo for pixel wafer is in now
c
c Revision 1.13  1997/11/06  18:32:32  yarba_j
c minor update to pixels representation
c
c Revision 1.6  1997/10/07  20:44:50  yarba_j
c fixed few bugs for updated representation/input for pixels
c
c Revision 1.3  1997/04/04  20:29:53  garren
c add rcs log line
c




