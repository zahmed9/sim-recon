      subroutine load_fordisk
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c      Coverage for each layer extends from phi(1) to phi(2)
c      Slices in phi are described by 
c                  nslice:  total number of slices
c                  j:       jth slice (1..nslice)
c                  beta:  phi angle from the x axis to the 
c                          center of each slice
c                  dbeta: angle between adjacent slice centers
c                         dbeta = phi(1)+phi(2))/nslice  
c                  dphi:  phi coverage of each slice
c
c                  beta = phi(1) + dphi/2 + (j-1)*dbeta 
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none
      integer i, j, ndisk, idet, ily, nchan, ncells, islice
      real stereo, dbeta, beta, ratio, rmn, rmx, width, cell_width
      real d_phi, dphi, cos_stereo, sin_stereo
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "fordisk.inc"
#include "const.inc"
      integer lenocc
      external lenocc
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      fordisk_num = min(max_fordisk,n_obj_fordisk)
      if (fordisk_num.gt.0) then
        write(mcp_llpt,*) 'Loading forward disks'
      endif

      do i=1,fordisk_num
        ndisk = min(max_fordisk,fordisk(i).num)
        fordisk_par(ndisk).name = 
     *             fordisk(i).name(:lenocc(fordisk(i).name))
        fordisk_par(ndisk).numlyr = 
     *             min(max_fordisk_lyr,fordisk(i).nlyr)
        fordisk_par(ndisk).nchan = 0
        fordisk_par(i).rmin = fordisk(i).rmin
        fordisk_par(i).rmax = fordisk(i).rmax
        fordisk_par(i).zmin = fordisk(i).z0 - fordisk(i).zlen/2.
        fordisk_par(i).zmax = fordisk(i).z0 + fordisk(i).zlen/2.
        call getmat(fordisk(i).material,fordisk_par(i).material)
        do j=1,4
          fordisk_par(i).thick_boun(j) = fordisk(i).thick_boun(j)
          call getmat(fordisk(i).mat_boun(j),fordisk_par(i).mat_boun(j))
        enddo
      enddo
*
*****   layers
*
      do i=1,n_obj_layerfodi
        idet = layerfodi(i).det
        ily = layerfodi(i).lyr
        fordisk_par(idet).lyr(ily).numslice = layerfodi(i).nslice
        fordisk_par(idet).lyr(ily).slice(1).z  = 
     &    fordisk(idet).z0 + layerfodi(i).z_local
        fordisk_par(idet).lyr(ily).slice(1).thick = layerfodi(i).thick
        fordisk_par(idet).lyr(ily).slice(1).rmin  = fordisk(idet).rmin
        fordisk_par(idet).lyr(ily).slice(1).rmax  = fordisk(idet).rmax
        fordisk_par(idet).lyr(ily).phi(1)         = layerfodi(i).phi(1)
        fordisk_par(idet).lyr(ily).phi(2)         = layerfodi(i).phi(2)
        dbeta = abs(layerfodi(i).phi(2) - layerfodi(i).phi(1))
     &    /     fordisk_par(idet).lyr(ily).numslice
        dphi  = layerfodi(i).dphi      
        beta  = fordisk_par(idet).lyr(ily).phi(1)+ dphi/2.
        fordisk_par(idet).lyr(ily).slice(1).beta = beta
        fordisk_par(idet).lyr(ily).slice(1).cos_beta = cos(beta)
        fordisk_par(idet).lyr(ily).slice(1).sin_beta = sin(beta)
        fordisk_par(idet).lyr(ily).slice(1).d_phi = dphi
        fordisk_par(idet).lyr(ily).slice(1).type = layerfodi(i).type
c         
        if (fordisk_par(idet).lyr(ily).numslice .gt. 1) then
          do j = 2,fordisk_par(idet).lyr(ily).numslice
            fordisk_par(idet).lyr(ily).slice(j).z =
     &        fordisk_par(idet).lyr(ily).slice(1).z
            fordisk_par(idet).lyr(ily).slice(j).thick =
     &        fordisk_par(idet).lyr(ily).slice(1).thick
            fordisk_par(idet).lyr(ily).slice(j).rmin =
     &        fordisk_par(idet).lyr(ily).slice(1).rmin
            fordisk_par(idet).lyr(ily).slice(j).rmax =
     &        fordisk_par(idet).lyr(ily).slice(1).rmax
            fordisk_par(idet).lyr(ily).slice(j).d_phi =
     &        fordisk_par(idet).lyr(ily).slice(1).d_phi
            fordisk_par(idet).lyr(ily).slice(j).type =
     &        fordisk_par(idet).lyr(ily).slice(1).type
            beta = fordisk_par(idet).lyr(ily).phi(1)
     &        + dphi / 2. + dbeta * (i - 1)
            fordisk_par(idet).lyr(ily).slice(j).beta = beta
            fordisk_par(idet).lyr(ily).slice(j).cos_beta = 
     &        cos(beta)
            fordisk_par(idet).lyr(ily).slice(j).sin_beta =
     &        sin(beta)
          end do
        end if
      enddo
*
*****   slices
*
      do i=1,n_obj_fdslice
        idet = min(fdslice(i).det,max_fordisk)
        ily = min(fdslice(i).lyr,max_fordisk_lyr)
        if (fdslice(i).speci(1:3) .eq. 'ALL') then
***         'ALL'
          stereo = fdslice(i).stereo
          cos_stereo = cos(stereo)
          sin_stereo = sin(stereo)
          d_phi = 2.*abs(fdslice(i).c0_phi)
          if (d_phi .gt. 0. .and.
     &       fdslice(i).c0_r .ge. 
     &          fordisk_par(idet).lyr(ily).slice(1).rmin
     &       .and.
     &       fdslice(i).c0_r .le. 
     &          fordisk_par(idet).lyr(ily).slice(1).rmax
     &       .and.
     &       fordisk_par(idet).lyr(ily).slice(1).rmax .gt.
     &       fordisk_par(idet).lyr(ily).slice(1).rmin) then
            ratio = 2. * fdslice(i).c0_r 
     &        / ( fordisk_par(idet).lyr(ily).slice(1).rmin
     &        +   fordisk_par(idet).lyr(ily).slice(1).rmax )
            if (ratio .le. 1.) then
              rmn = fdslice(i).c0_r
              rmx = fordisk_par(idet).lyr(ily).slice(1).rmax
     &          - fdslice(i).c0_r 
     &          + fordisk_par(idet).lyr(ily).slice(1).rmin
            else
              rmx = fdslice(i).c0_r
              rmn = fordisk_par(idet).lyr(ily).slice(1).rmin
     &          + fordisk_par(idet).lyr(ily).slice(1).rmax
     &          - fdslice(i).c0_r
            end if
            if (abs(stereo) .le. d_phi/2.) then
              width = 2. * rmx * tan(0.5 * d_phi)
              cell_width = fdslice(i).cell_width / cos_stereo
              ncells = int( width / cell_width )
            else if (abs(stereo) .gt. d_phi/2. .and.
     &          abs(stereo) .le. pi/4.) then
              width = (rmx - rmn) / cos(0.5*d_phi)
     &          + 2.* rmn * tan(0.5*d_phi) * cos_stereo
              ncells = int( width / fdslice(i).cell_width )
            end if
            if (ncells .lt. int(fdslice(i).ncells)) then
              write(mcp_llpt,6000) idet, ily, ncells
 6000         format('FOR DISK ', i4, ' LAYER ', i4, ' :', /,
     &          'max number of strips on slice can not exceed ', i8)
              fdslice(i).ncells = float(ncells)
            end if
          end if
c
          fordisk_par(idet).nchan = fordisk_par(idet).nchan
     &      - fordisk_par(idet).lyr(ily).nchan
          if (fordisk_par(idet).lyr(ily).numslice .gt. 0) then
            do islice = 1,fordisk_par(idet).lyr(ily).numslice
              nchan = nchan + int(fdslice(i).ncells)
              fordisk_par(idet).lyr(ily).slice(islice).ncells = 
     &          int(fdslice(i).ncells)
              fordisk_par(idet).lyr(ily).slice(islice).nchan  = 
     &          int(fdslice(i).ncells)
              fordisk_par(idet).lyr(ily).slice(islice).coord0_r = 
     &          fdslice(i).c0_r
              fordisk_par(idet).lyr(ily).slice(islice).coord0_phi = 
     &          fdslice(i).c0_phi
              fordisk_par(idet).lyr(ily).slice(islice).chan0  = 0
              fordisk_par(idet).lyr(ily).slice(islice).cell_width  = 
     &          fdslice(i).cell_width
              fordisk_par(idet).lyr(ily).slice(islice).stereo = stereo
              fordisk_par(idet).lyr(ily).slice(islice).cos_stereo = 
     &          cos_stereo
              fordisk_par(idet).lyr(ily).slice(islice).sin_stereo = 
     &          sin_stereo
              fordisk_par(idet).lyr(ily).slice(islice).eff_hit = 
     &          fdslice(i).eff_hit
              fordisk_par(idet).lyr(ily).slice(islice).siga   = 
     &          fdslice(i).siga
              fordisk_par(idet).lyr(ily).slice(islice).sigb   = 
     &          fdslice(i).sigb
              fordisk_par(idet).lyr(ily).slice(islice).sigc   = 
     &          fdslice(i).sigc
            end do
          end if
          fordisk_par(idet).lyr(ily).nchan = nchan
          fordisk_par(idet).nchan = fordisk_par(idet).nchan 
     &      + fordisk_par(idet).lyr(ily).nchan
*           
        else if (fdslice(i).speci(1:3) .eq. 'SPC') then
***         'SPC'
          islice = min(fdslice(i).nslice,max_fordisk_slice)
          stereo = fdslice(i).stereo
          cos_stereo = cos(stereo)
          sin_stereo = sin(stereo)
          d_phi = 2.*abs(fdslice(i).c0_phi)
          if (d_phi .gt. 0. .and.
     &      fdslice(i).c0_r .ge.
     &          fordisk_par(idet).lyr(ily).slice(islice).rmin
     &      .and.
     &      fdslice(i).c0_r .le.
     &          fordisk_par(idet).lyr(ily).slice(islice).rmax
     &       .and.
     &      fordisk_par(idet).lyr(ily).slice(1).rmax .gt.
     &      fordisk_par(idet).lyr(ily).slice(1).rmin) then
            ratio = 2.*fdslice(i).c0_r
     &        / (fordisk_par(idet).lyr(ily).slice(islice).rmin
     &        +  fordisk_par(idet).lyr(ily).slice(islice).rmax)
            if (ratio .le. 1.) then
              rmn = fdslice(i).c0_r
              rmx = fordisk_par(idet).lyr(ily).slice(1).rmax
     &          - fdslice(i).c0_r
     &          + fordisk_par(idet).lyr(ily).slice(1).rmin
            else
              rmx = fdslice(i).c0_r
              rmn = fordisk_par(idet).lyr(ily).slice(1).rmin
     &          + fordisk_par(idet).lyr(ily).slice(1).rmax
     &          - fdslice(i).c0_r
            end if
            if (abs(stereo) .le. d_phi/2.) then
              width = 2. * rmx * tan(0.5 * d_phi)
              cell_width = fdslice(i).cell_width / cos_stereo
              ncells = int( width / cell_width )
            else if (abs(stereo) .gt. d_phi/2. .and.
     &          abs(stereo) .le. pi/4.) then
              width = (rmx - rmn) / cos(0.5*d_phi)
     &          + 2. * rmn * tan(0.5*d_phi) * cos_stereo
              ncells = int( width / fdslice(i).cell_width )
            end if
            if (ncells .lt. fdslice(i).ncells) then
              write(mcp_llpt,6001) idet, ily, islice, ncells
 6001         format('SI DISK ', i4, ' LAY ', i4, 'slice ', i4, ' :', /,
     &          'max number of strips on slice can not exceed ', i8)
              fdslice(i).ncells = ncells
            end if
          end if
*           
          fordisk_par(idet).nchan = fordisk_par(idet).nchan
     &      - fordisk_par(idet).lyr(ily).slice(islice).nchan
          fordisk_par(idet).lyr(ily).nchan = 
     &      fordisk_par(idet).lyr(ily).nchan
     &      - fordisk_par(idet).lyr(ily).slice(islice).nchan
          fordisk_par(idet).lyr(ily).slice(islice).ncells = 
     &      fdslice(i).ncells
          fordisk_par(idet).lyr(ily).slice(islice).nchan  = 
     &      fordisk_par(idet).lyr(ily).slice(islice).nchan  
     &      + fdslice(i).ncells
          fordisk_par(idet).nchan = fordisk_par(idet).nchan + 
     &      fdslice(i).ncells
          fordisk_par(idet).lyr(ily).slice(islice).coord0_r = 
     &      fdslice(i).c0_r
          fordisk_par(idet).lyr(ily).slice(islice).coord0_phi = 
     &      fdslice(i).c0_phi
          fordisk_par(idet).lyr(ily).slice(islice).chan0  = 0
          fordisk_par(idet).lyr(ily).slice(islice).cell_width  = 
     &      fdslice(i).cell_width
          fordisk_par(idet).lyr(ily).slice(islice).stereo = 
     &      stereo
          fordisk_par(idet).lyr(ily).slice(islice).cos_stereo = 
     &      cos_stereo
          fordisk_par(idet).lyr(ily).slice(islice).sin_stereo = 
     &      sin_stereo
          fordisk_par(idet).lyr(ily).slice(islice).eff_hit = 
     &      fdslice(i).eff_hit
          fordisk_par(idet).lyr(ily).slice(islice).siga   = 
     &      fdslice(i).siga
          fordisk_par(idet).lyr(ily).slice(islice).sigb   = 
     &      fdslice(i).sigb
          fordisk_par(idet).lyr(ily).slice(islice).sigc   = 
     &      fdslice(i).sigc
        end if
      enddo
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:50  garren
c add rcs log line
c
