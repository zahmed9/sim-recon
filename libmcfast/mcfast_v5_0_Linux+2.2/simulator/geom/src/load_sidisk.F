      subroutine load_sidisk
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Correction and Comments added by plm 7/6/96
c
c      Coverage for each layer extends from phi(1) to phi(2)
c      There can be gaps between wedges 
c
c      All adjacent wedges at one z location are in put in one zplane
c      The first wedge at this particular z location is iw
c                   --> see routine geo_trkorder
c
c      Wedges in phi are described by 
c             nwedge:  total number of wedges
c             iwedge:    ith wedge (1..nwedge)
c             beta:  phi angle from the x axis to the 
c                          center of each wedge
c             phi(2)-phi(1): phi coverage of layer if dphi= dbeta
c
c             dbeta: angle between adjacent wedge centers
c                         dbeta = (phi(2)-phi(1))/nwedge  
c             dphi:  phi coverage of each wedge  --
c                 overlapping wedges should be at different z locations
c
c             beta = phi(1) + dbeta/2 + (iwedge-1)*dbeta
c 
c     currently the z position is the same for all wedges in a layer
c     this is the way the geometry template is constructed
c     this cannot be true if there are overlapping wedges in a "layer"
c 
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      implicit none
      
      integer i, j, ndisk, idet, ily, nchan, nstrip, iwed
      real stereo, dbeta, beta, dphi, ratio, rmn, rmx, width, pitch
      real d_phi, cos_stereo, sin_stereo
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "sicir_disk.inc"
#include "const.inc"
      integer lenocc
      external lenocc
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      sicir_num = min(max_sicir,n_obj_sidisk)
      if (sicir_num.gt.0) then
        write(mcp_llpt,*) 'Loading Si disks'
      endif

      do i=1,sicir_num
        ndisk = min(max_sicir,sidisk(i).num)
        sicir_par(ndisk).name = sidisk(i).name(:lenocc(sidisk(i).name))
        sicir_par(ndisk).numlyr = min(max_sicir_lyr,sidisk(i).nlyr)
        sicir_par(ndisk).z = sidisk(i).zpos
        sicir_par(ndisk).nchan = 0
      enddo
*
*****   layers
*
      do i=1,n_obj_layersidi
        idet = layersidi(i).det
        ily = layersidi(i).lyr
        call getmat(layersidi(i).mat,
     +    sicir_par(idet).lyr(ily).wedge(1).material)
        if ( layersidi(i).nwed .eq. 2 .and. 
     +       layersidi(i).type .eq. 4        ) then
           print *, ' '
           print *, 'Illegal geometry.  Program will stop.'
           print *, 'Silicon Disk of type 4 with 2 wedges is illegal.'
           print *, 'type 4: trapazoid which exscribes the circle.'
           print *, 'Try: Silicon disk type=3 (circular).'
           print *, ' or  SizRect (square plane) devices.'
           print *, ' or  more than 2 wedges.'
           stop
        endif
        sicir_par(idet).lyr(ily).numwedge = layersidi(i).nwed
        sicir_par(idet).lyr(ily).wedge(1).z  = 
     &    sicir_par(idet).z + layersidi(i).z_local
        sicir_par(idet).lyr(ily).wedge(1).thick = layersidi(i).thick
        sicir_par(idet).lyr(ily).wedge(1).rmin  = layersidi(i).rmin
        sicir_par(idet).lyr(ily).wedge(1).rmax  = layersidi(i).rmax
        sicir_par(idet).lyr(ily).phi(1)         = layersidi(i).phi(1)
        sicir_par(idet).lyr(ily).phi(2)         = layersidi(i).phi(2)
        dbeta = abs(layersidi(i).phi(2) - layersidi(i).phi(1))
     &    /     sicir_par(idet).lyr(ily).numwedge
        dphi = layersidi(i).dphi
        sicir_par(idet).lyr(ily).wedge(1).d_phi = dphi
        sicir_par(idet).lyr(ily).wedge(1).type = layersidi(i).type
        beta = sicir_par(idet).lyr(ily).phi(1) + dbeta / 2. 
        sicir_par(idet).lyr(ily).wedge(1).beta = beta
        sicir_par(idet).lyr(ily).wedge(1).cos_beta = cos(beta)
        sicir_par(idet).lyr(ily).wedge(1).sin_beta = sin(beta)
c         
        if (sicir_par(idet).lyr(ily).numwedge .gt. 1) then
          do j = 2,sicir_par(idet).lyr(ily).numwedge
            sicir_par(idet).lyr(ily).wedge(j).material =
     &        sicir_par(idet).lyr(ily).wedge(1).material
            sicir_par(idet).lyr(ily).wedge(j).z =
     &        sicir_par(idet).lyr(ily).wedge(1).z
            sicir_par(idet).lyr(ily).wedge(j).thick =
     &        sicir_par(idet).lyr(ily).wedge(1).thick
            sicir_par(idet).lyr(ily).wedge(j).rmin =
     &        sicir_par(idet).lyr(ily).wedge(1).rmin
            sicir_par(idet).lyr(ily).wedge(j).rmax =
     &        sicir_par(idet).lyr(ily).wedge(1).rmax
            sicir_par(idet).lyr(ily).wedge(j).d_phi =
     &        sicir_par(idet).lyr(ily).wedge(1).d_phi
            sicir_par(idet).lyr(ily).wedge(j).type =
     &        sicir_par(idet).lyr(ily).wedge(1).type
            beta = sicir_par(idet).lyr(ily).phi(1)
     &        +  dbeta / 2. + dbeta * (j - 1)
            sicir_par(idet).lyr(ily).wedge(j).beta = beta
            sicir_par(idet).lyr(ily).wedge(j).cos_beta = 
     &        cos(beta)
            sicir_par(idet).lyr(ily).wedge(j).sin_beta =
     &        sin(beta)
          end do
        end if
      enddo
*
*****   Wedges
*
      do i=1,n_obj_wedge
        idet = min(wedge(i).det,max_sicir)
        ily = min(wedge(i).lyr,max_sicir_lyr)
        if (wedge(i).speci(1:3) .eq. 'ALL') then
***         'ALL'
          stereo = wedge(i).stereo
          cos_stereo = cos(stereo)
          sin_stereo = sin(stereo)
          d_phi = 2.*abs(wedge(i).c0_phi)
          if (d_phi .gt. 0. .and.
     &       wedge(i).c0_r .ge. sicir_par(idet).lyr(ily).wedge(1).rmin
     &       .and.
     &       wedge(i).c0_r .le. sicir_par(idet).lyr(ily).wedge(1).rmax
     &       .and.
     &       sicir_par(idet).lyr(ily).wedge(1).rmax .gt.
     &       sicir_par(idet).lyr(ily).wedge(1).rmin) then
            ratio = 2. * wedge(i).c0_r 
     &        / ( sicir_par(idet).lyr(ily).wedge(1).rmin
     &        +   sicir_par(idet).lyr(ily).wedge(1).rmax )
            if (ratio .le. 1.) then
              rmn = wedge(i).c0_r
              rmx = sicir_par(idet).lyr(ily).wedge(1).rmax
     &          - wedge(i).c0_r 
     &          + sicir_par(idet).lyr(ily).wedge(1).rmin
            else
              rmx = wedge(i).c0_r
              rmn = sicir_par(idet).lyr(ily).wedge(1).rmin
     &          + sicir_par(idet).lyr(ily).wedge(1).rmax
     &          - wedge(i).c0_r
            end if
            if (abs(stereo) .le. d_phi/2.) then
              width = 2. * rmx * tan(0.5 * d_phi)
              pitch = wedge(i).pitch / cos_stereo
              nstrip = int( width / pitch )
            else if (abs(stereo) .gt. d_phi/2. .and.
     &          abs(stereo) .le. pi/4.) then
              width = (rmx - rmn) / cos(0.5*d_phi)
     &          + 2.* rmn * tan(0.5*d_phi) * cos_stereo
              nstrip = int( width / wedge(i).pitch )
            end if
            if (nstrip .lt. int(wedge(i).nstrip)) then
              write(mcp_llpt,6000) idet, ily, nstrip
 6000         format('SI DISK ', i4, ' LAYER ', i4, ' :', /,
     &          'max number of strips on wedge can not exceed ', i8)
              wedge(i).nstrip = float(nstrip)
            end if
          end if
c
          sicir_par(idet).nchan = sicir_par(idet).nchan
     &      - sicir_par(idet).lyr(ily).nchan
          if (sicir_par(idet).lyr(ily).numwedge .gt. 0) then
            do iwed = 1,sicir_par(idet).lyr(ily).numwedge
              nchan = nchan + int(wedge(i).nstrip)
              sicir_par(idet).lyr(ily).wedge(iwed).nstrip = 
     &          int(wedge(i).nstrip)
              sicir_par(idet).lyr(ily).wedge(iwed).nchan  = 
     &          int(wedge(i).nstrip)
              sicir_par(idet).lyr(ily).wedge(iwed).coord0_r = 
     &          wedge(i).c0_r
              sicir_par(idet).lyr(ily).wedge(iwed).coord0_phi = 
     &          wedge(i).c0_phi
              sicir_par(idet).lyr(ily).wedge(iwed).chan0  = 0
              sicir_par(idet).lyr(ily).wedge(iwed).pitch  = 
     &          wedge(i).pitch
              sicir_par(idet).lyr(ily).wedge(iwed).stereo = stereo
              sicir_par(idet).lyr(ily).wedge(iwed).cos_stereo = 
     &          cos_stereo
              sicir_par(idet).lyr(ily).wedge(iwed).sin_stereo = 
     &          sin_stereo
              sicir_par(idet).lyr(ily).wedge(iwed).eff_hit = 
     &          wedge(i).eff_hit
              sicir_par(idet).lyr(ily).wedge(iwed).siga   = 
     &          wedge(i).siga
              sicir_par(idet).lyr(ily).wedge(iwed).sigb   = 
     &          wedge(i).sigb
              sicir_par(idet).lyr(ily).wedge(iwed).sigc   = 
     &          wedge(i).sigc
            end do
          end if
          sicir_par(idet).lyr(ily).nchan = nchan
          sicir_par(idet).nchan = sicir_par(idet).nchan 
     &      + sicir_par(idet).lyr(ily).nchan
*           
        else if (wedge(i).speci(1:3) .eq. 'SPC') then
***         'SPC'
          iwed = min(wedge(i).nwed,max_sicir_wedge)
          stereo = wedge(i).stereo
          cos_stereo = cos(stereo)
          sin_stereo = sin(stereo)
          d_phi = 2.*abs(wedge(i).c0_phi)
          if (d_phi .gt. 0. .and.
     &      wedge(i).c0_r.ge.sicir_par(idet).lyr(ily).wedge(iwed).rmin
     &      .and.
     &      wedge(i).c0_r.le.sicir_par(idet).lyr(ily).wedge(iwed).rmax
     &       .and.
     &      sicir_par(idet).lyr(ily).wedge(1).rmax .gt.
     &      sicir_par(idet).lyr(ily).wedge(1).rmin) then
            ratio = 2.*wedge(i).c0_r
     &        / (sicir_par(idet).lyr(ily).wedge(iwed).rmin
     &        +  sicir_par(idet).lyr(ily).wedge(iwed).rmax)
            if (ratio .le. 1.) then
              rmn = wedge(i).c0_r
              rmx = sicir_par(idet).lyr(ily).wedge(1).rmax
     &          - wedge(i).c0_r
     &          + sicir_par(idet).lyr(ily).wedge(1).rmin
            else
              rmx = wedge(i).c0_r
              rmn = sicir_par(idet).lyr(ily).wedge(1).rmin
     &          + sicir_par(idet).lyr(ily).wedge(1).rmax
     &          - wedge(i).c0_r
            end if
            if (abs(stereo) .le. d_phi/2.) then
              width = 2. * rmx * tan(0.5 * d_phi)
              pitch = wedge(i).pitch / cos_stereo
              nstrip = int( width / pitch )
            else if (abs(stereo) .gt. d_phi/2. .and.
     &          abs(stereo) .le. pi/4.) then
              width = (rmx - rmn) / cos(0.5*d_phi)
     &          + 2. * rmn * tan(0.5*d_phi) * cos_stereo
              nstrip = int( width / wedge(i).pitch )
            end if
            if (nstrip .lt. wedge(i).nstrip) then
              write(mcp_llpt,6001) idet, ily, iwed, nstrip
 6001         format('SI DISK ', i4, ' LAY ', i4, 'WEDGE ', i4, ' :', /,
     &          'max number of strips on wedge can not exceed ', i8)
              wedge(i).nstrip = nstrip
            end if
          end if
*           
          sicir_par(idet).nchan = sicir_par(idet).nchan
     &      - sicir_par(idet).lyr(ily).wedge(iwed).nchan
          sicir_par(idet).lyr(ily).nchan = 
     &      sicir_par(idet).lyr(ily).nchan
     &      - sicir_par(idet).lyr(ily).wedge(iwed).nchan
          sicir_par(idet).lyr(ily).wedge(iwed).nstrip = 
     &      wedge(i).nstrip
          sicir_par(idet).lyr(ily).wedge(iwed).nchan  = 
     &      sicir_par(idet).lyr(ily).wedge(iwed).nchan  
     &      + wedge(i).nstrip
          sicir_par(idet).nchan = sicir_par(idet).nchan + 
     &      wedge(i).nstrip
          sicir_par(idet).lyr(ily).wedge(iwed).coord0_r = 
     &      wedge(i).c0_r
          sicir_par(idet).lyr(ily).wedge(iwed).coord0_phi = 
     &      wedge(i).c0_phi
          sicir_par(idet).lyr(ily).wedge(iwed).chan0  = 0
          sicir_par(idet).lyr(ily).wedge(iwed).pitch  = 
     &      wedge(i).pitch
          sicir_par(idet).lyr(ily).wedge(iwed).stereo = 
     &      stereo
          sicir_par(idet).lyr(ily).wedge(iwed).cos_stereo = 
     &      cos_stereo
          sicir_par(idet).lyr(ily).wedge(iwed).sin_stereo = 
     &      sin_stereo
          sicir_par(idet).lyr(ily).wedge(iwed).eff_hit = 
     &      wedge(i).eff_hit
          sicir_par(idet).lyr(ily).wedge(iwed).siga   = 
     &      wedge(i).siga
          sicir_par(idet).lyr(ily).wedge(iwed).sigb   = 
     &      wedge(i).sigb
          sicir_par(idet).lyr(ily).wedge(iwed).sigc   = 
     &      wedge(i).sigc
        end if
      enddo
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.6  1999/07/27 22:51:18  kutschke
c Stop on illegal type=4 and nwed=2.
c
c Revision 1.5  1997/04/04  20:29:53  garren
c add rcs log line
c
