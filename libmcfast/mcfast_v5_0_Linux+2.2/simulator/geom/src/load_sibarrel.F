      subroutine load_sibarrel
      implicit none
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "si_barrel.inc"
#include "const.inc"
      integer i, j, idet, ily, nstrip, i_waf, nchan
      real dbeta, beta, stereo, cos_stereo, sin_stereo, phi_waf
      real z_waf, delta, dmax
      integer lenocc
      external lenocc

      nchan = 0
      sib_num = min(max_sib,n_obj_sibarrel)
      if (sib_num.gt.0) then
        write(mcp_llpt,*) 'Loading Si barrel'
      endif

      do i=1,sib_num
        sib_par(i).name = sibarrel(i).name(:lenocc(sibarrel(i).name))
        sib_par(i).numlyr = min(sibarrel(i).nlyr,max_sib_lyr)
        sib_par(i).z = sibarrel(i).z0_global
      enddo
*
***     load the layers
      do i=1,n_obj_layersib
        idet = min(layersib(i).det,max_sib)
        ily = min(layersib(i).lyr,max_sib_lyr)
        call getmat(layersib(i).mat,
     +    sib_par(idet).lyr(ily).plane(1).material)
        sib_par(idet).lyr(ily).numplane = min(layersib(i).nwaf,
     +    max_sib_plane)
        sib_par(idet).lyr(ily).plane(1).zmin = sib_par(idet).z -
     +    layersib(i).zlen/2.
        sib_par(idet).lyr(ily).plane(1).zmax = sib_par(idet).z +
     +    layersib(i).zlen/2.
        sib_par(idet).lyr(ily).plane(1).beta = layersib(i).beta
        delta = layersib(i).delta
        sib_par(idet).lyr(ily).plane(1).delta_min =
     +    layersib(i).delta
        sib_par(idet).lyr(ily).plane(1).thick = layersib(i).thick
        sib_par(idet).lyr(ily).plane(1).dmin = -layersib(i).width/2.
        sib_par(idet).lyr(ily).plane(1).dmax =  layersib(i).width/2.
        sib_par(idet).lyr(ily).plane(1).delta_max = sqrt(
     +    layersib(i).delta**2 + layersib(i).width**2 / 4. )
        sib_par(idet).lyr(ily).plane(1).type = layersib(i).type

        dbeta = tpi / sib_par(idet).lyr(ily).numplane
c
        if (sib_par(idet).lyr(ily).numplane .gt. 0) then
          do i_waf = 1,sib_par(idet).lyr(ily).numplane
            sib_par(idet).lyr(ily).plane(i_waf).material  =
     &        sib_par(idet).lyr(ily).plane(1).material
            sib_par(idet).lyr(ily).plane(i_waf).zmin      = 
     &        sib_par(idet).lyr(ily).plane(1).zmin    
            sib_par(idet).lyr(ily).plane(i_waf).zmax      = 
     &        sib_par(idet).lyr(ily).plane(1).zmax    
            sib_par(idet).lyr(ily).plane(i_waf).dmin      = 
     &        sib_par(idet).lyr(ily).plane(1).dmin    
            sib_par(idet).lyr(ily).plane(i_waf).dmax      = 
     &        sib_par(idet).lyr(ily).plane(1).dmax    
            sib_par(idet).lyr(ily).plane(i_waf).delta_min = 
     &        sib_par(idet).lyr(ily).plane(1).delta_min
            sib_par(idet).lyr(ily).plane(i_waf).delta_max = 
     &        sib_par(idet).lyr(ily).plane(1).delta_max
            sib_par(idet).lyr(ily).plane(i_waf).thick     = 
     &        sib_par(idet).lyr(ily).plane(1).thick
            sib_par(idet).lyr(ily).plane(i_waf).type      = 
     &        sib_par(idet).lyr(ily).plane(1).type
            beta = sib_par(idet).lyr(ily).plane(1).beta 
     &        + dbeta * (i_waf - 1)
            sib_par(idet).lyr(ily).plane(i_waf).beta    = beta
            sib_par(idet).lyr(ily).plane(i_waf).eta(1)  = cos(beta)
            sib_par(idet).lyr(ily).plane(i_waf).eta(2)  = sin(beta)
            sib_par(idet).lyr(ily).plane(i_waf).eta(3)  = 0.
            sib_par(idet).lyr(ily).plane(i_waf).xpos(1) = 
     &        delta * cos(beta)
            sib_par(idet).lyr(ily).plane(i_waf).xpos(2) = 
     &        delta * sin(beta)
            sib_par(idet).lyr(ily).plane(i_waf).xpos(3) = 
     &        sib_par(idet).z
          enddo            
        endif
      enddo
*
***     load the wafers
      do i=1, n_obj_wafer
        idet = min(wafer(i).det,max_sib)
        ily = min(wafer(i).lyr,max_sib_lyr)
        if (wafer(i).speci(1:3).eq.'ALL') then
c           
          if (sib_par(idet).lyr(ily).numplane .gt. max_sib_plane)
     &      sib_par(idet).lyr(ily).numplane = max_sib_plane
          stereo = wafer(i).stereo
          cos_stereo = cos(stereo)
          sin_stereo = sin(stereo)
c
          phi_waf = 2. * abs(wafer(i).c0x)
          z_waf   = 2. * abs(wafer(i).c0y)
          if (phi_waf .gt. 0. .and. z_waf .gt. 0.) then
            if (sib_par(idet).lyr(ily).plane(1).type 
     &        .eq. 1) then
              nstrip = nint(phi_waf / wafer(i).pitch)
            else if (sib_par(idet).lyr(ily).plane(1).type 
     &          .eq. 2) then
              nstrip = z_waf / wafer(i).pitch
            end if
            if (nstrip .lt. wafer(i).nstrip ) then
              write(mcp_llpt,6000) idet, ily, nstrip, wafer(i).nstrip
 6000         format('SI BARREL ', i4, ' LAYER ', i4,' :', /,
     &          ' max number of strips on plane can not exceed ',2i8)
            end if
          end if
c
          sib_par(idet).nchan = sib_par(idet).nchan 
     &      - sib_par(idet).lyr(ily).nchan
c
          if (sib_par(idet).lyr(ily).numplane .gt. 0) then
            do i_waf = 1,sib_par(idet).lyr(ily).numplane
              sib_par(idet).lyr(ily).plane(i_waf).tilt =
     +          wafer(i).tilt
              if (wafer(i).tilt .ne. 0.0) then
                beta = sib_par(idet).lyr(ily).plane(i_waf).beta
     +               + wafer(i).tilt
                sib_par(idet).lyr(ily).plane(i_waf).beta = beta
                sib_par(idet).lyr(ily).plane(i_waf).eta(1) = cos(beta)
                sib_par(idet).lyr(ily).plane(i_waf).eta(2) = sin(beta)
                sib_par(idet).lyr(ily).plane(i_waf).eta(3) = 0.
                delta = sib_par(idet).lyr(ily).plane(i_waf).delta_min
                dmax = sib_par(idet).lyr(ily).plane(i_waf).dmax
                sib_par(idet).lyr(ily).plane(i_waf).delta_min = 
     &             sqrt((delta - dmax * sin(wafer(i).tilt))**2 +
     &                   (dmax * cos(wafer(i).tilt))**2)
                sib_par(idet).lyr(ily).plane(i_waf).delta_max = 
     &             sqrt((delta + dmax * sin(wafer(i).tilt))**2 +
     &                   (dmax * cos(wafer(i).tilt))**2)
              endif
              nchan = nchan + wafer(i).nstrip
              sib_par(idet).lyr(ily).plane(i_waf).nstrip   = 
     &          wafer(i).nstrip
              sib_par(idet).lyr(ily).plane(i_waf).nchan    = 
     &          wafer(i).nstrip
              sib_par(idet).lyr(ily).plane(i_waf).coord0_x = 
     &          wafer(i).c0x
              sib_par(idet).lyr(ily).plane(i_waf).coord0_y = 
     &          wafer(i).c0y
              sib_par(idet).lyr(ily).plane(i_waf).chan0    = 0
              sib_par(idet).lyr(ily).plane(i_waf).pitch    = 
     &          wafer(i).pitch
              sib_par(idet).lyr(ily).plane(i_waf).stereo = stereo
              sib_par(idet).lyr(ily).plane(i_waf).cos_stereo = 
     &          cos_stereo
              sib_par(idet).lyr(ily).plane(i_waf).sin_stereo = 
     &          sin_stereo
              sib_par(idet).lyr(ily).plane(i_waf).eff_hit = 
     &          wafer(i).eff_hit
              sib_par(idet).lyr(ily).plane(i_waf).siga =
     +          wafer(i).siga
              sib_par(idet).lyr(ily).plane(i_waf).sigb =
     +          wafer(i).sigb
              sib_par(idet).lyr(ily).plane(i_waf).sigc =
     +          wafer(i).sigc
            end do
            sib_par(idet).lyr(ily).nchan = nchan
            sib_par(idet).nchan = sib_par(idet).nchan
     &        + sib_par(idet).lyr(ily).nchan
          end if
c           
        else if (wafer(i).speci(1:3) .eq. 'SPC') then
c
          i_waf = min(wafer(i).nwaf,max_sib_plane)
          sib_par(idet).lyr(ily).plane(i_waf).tilt = wafer(i).tilt
          if (wafer(i).tilt .ne. 0.0) then
             beta = sib_par(idet).lyr(ily).plane(i_waf).beta
     +               + wafer(i).tilt
             sib_par(idet).lyr(ily).plane(i_waf).beta = beta
             sib_par(idet).lyr(ily).plane(i_waf).eta(1) = cos(beta)
             sib_par(idet).lyr(ily).plane(i_waf).eta(2) = sin(beta)
             sib_par(idet).lyr(ily).plane(i_waf).eta(3) = 0.
             delta = sib_par(idet).lyr(ily).plane(i_waf).delta_min
             dmax = sib_par(idet).lyr(ily).plane(i_waf).dmax
             sib_par(idet).lyr(ily).plane(i_waf).delta_min = 
     &          sqrt((delta - dmax * sin(wafer(i).tilt))**2 +
     &                   (dmax * cos(wafer(i).tilt))**2)
             sib_par(idet).lyr(ily).plane(i_waf).delta_max = 
     &          sqrt((delta + dmax * sin(wafer(i).tilt))**2 + 
     &                   (dmax * cos(wafer(i).tilt))**2)
          endif
c           
          phi_waf = 2. * abs(wafer(i).c0x)
          z_waf   = 2. * abs(wafer(i).c0y)
          if (phi_waf .gt. 0. .and. z_waf .gt. 0.) then
c             
            if (sib_par(idet).lyr(ily).plane(i_waf).type 
     &        .eq. 1) then
              nstrip = phi_waf / wafer(i).pitch
            else if (sib_par(idet).lyr(ily).plane(i_waf).type 
     &          .eq. 2) then
              nstrip = z_waf / wafer(i).pitch
            end if
            if (nstrip .lt. wafer(i).nstrip ) then
              write(mcp_llpt,6001) idet, ily, i_waf, nstrip
 6001         format('SI BARREL ', i4, ' LAYER ', i4, ' WAFER ',
     +          i4, ' :', /,
     &          ' max number of strips on plane can not exceed ', i8)
            end if
c             
          end if
c           
          sib_par(idet).nchan = sib_par(idet).nchan
     &      - sib_par(idet).lyr(ily).plane(i_waf).nchan
          sib_par(idet).lyr(ily).nchan = 
     &      sib_par(idet).lyr(ily).nchan
     &      -  sib_par(idet).lyr(ily).plane(i_waf).nchan
          sib_par(idet).lyr(ily).plane(i_waf).nstrip = 
     &      wafer(i).nstrip
          sib_par(idet).lyr(ily).nchan = 
     &      sib_par(idet).lyr(ily).nchan
     &      + wafer(i).nstrip
          sib_par(idet).nchan = sib_par(idet).nchan 
     &      + wafer(i).nstrip
c           
          sib_par(idet).lyr(ily).plane(i_waf).coord0_x =
     +          wafer(i).c0x
          sib_par(idet).lyr(ily).plane(i_waf).coord0_y =
     +          wafer(i).c0y
          sib_par(idet).lyr(ily).plane(i_waf).pitch  =
     +          wafer(i).pitch
          sib_par(idet).lyr(ily).plane(i_waf).stereo =
     +      wafer(i).stereo
          sib_par(idet).lyr(ily).plane(i_waf).cos_stereo = 
     +      cos(wafer(i).stereo)
          sib_par(idet).lyr(ily).plane(i_waf).sin_stereo = 
     +      sin(wafer(i).stereo)
          sib_par(idet).lyr(ily).plane(i_waf).eff_hit =
     +      wafer(i).eff_hit
          sib_par(idet).lyr(ily).plane(i_waf).siga = wafer(i).siga
          sib_par(idet).lyr(ily).plane(i_waf).sigb = wafer(i).sigb
          sib_par(idet).lyr(ily).plane(i_waf).sigc = wafer(i).sigc
        end if        
      enddo

      do i=1,sib_num
        write(mcp_llpt,'(a,i4,i8,f9.3)') '   SiBar '//
     +    sib_par(i).name(:lenocc(sib_par(i).name))//
     +    ' nly,nch,z0',
     +    sib_par(i).numlyr,sib_par(i).nchan,sib_par(i).z
      enddo

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.8  1998/05/19 23:43:27  kutschke
c Ugly hack to kill error message. (nint)
c
c Revision 1.7  1997/04/04  20:29:52  garren
c add rcs log line
c
