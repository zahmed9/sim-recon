      subroutine geo_fill_drift(keyword,nstart,i_fill,buffer,char_name)
c
      implicit none
c
#include "mcp_luns.inc"
#include "material.inc"
#include "drift.inc"
#include "const.inc"
c
      character*(*) keyword
c
      integer nstart, i_fill
c
      real buffer(*)
c
      character*(*) char_name
c
      integer num_drf
      integer i
      integer boundry
      integer i_det, i_lyr
      integer id_mat
      integer nchan
      real z_center_global, zmin, zmax
      integer stereo
      real x_phi, x_tg_tau, tanphi
c
c
c
      i_det   = 0
      i_lyr   = 0
      id_mat  = 0
      nchan   = 0
      z_center_global = 0.
      zmin    = 0.
      zmax    = 0.
c
c
c
      if (keyword .eq. 'DRIFT') then
c
      num_drf = int(buffer(2))
c
      if (num_drf .gt. max_drf) num_drf = max_drf
c
       if (i_fill .eq. 0) then
c
        if (char_name .ne. ' ') then
c
         if (nstart .eq. 2) then
          drf_num = drf_num + 1
          drf_par(num_drf).name = char_name
         end if
         if (nstart .eq. 9) then
          do i = 1,mtl_num
           if (mtl_par(i).name .eq. char_name) then
            drf_par(num_drf).material = i
            goto 100
           end if
          end do
  100     if (drf_par(num_drf).material .le. 0 .or.
     &        drf_par(num_drf).material .gt. mtl_num) then
           write(mcp_llpt,5000) num_drf
          end if
         end if
         if (nstart .gt. 13) then
          boundry = nstart - 13
          do i = 1,mtl_num
           if (mtl_par(i).name .eq. char_name) then
            drf_par(num_drf).mat_boun(boundry) = i
            goto 200
           end if
          end do
  200     if (drf_par(num_drf).mat_boun(boundry).le.0.or.
     &        drf_par(num_drf).mat_boun(boundry).gt.mtl_num) then
           write(mcp_llpt,5001) num_drf, boundry
          end if
         end if
c
        end if
c
       end if
c
       if (i_fill .gt. 0) then
        drf_par(num_drf).num_anode = int(buffer(4))
        if (drf_par(num_drf).num_anode .gt. max_drf_anode) then
         drf_par(num_drf).num_anode = max_drf_anode
        end if
        drf_par(num_drf).num_cathode = int(buffer(5))
        if (drf_par(num_drf).num_cathode .gt. max_drf_cathode) then
         drf_par(num_drf).num_cathode = max_drf_cathode
        end if
        drf_par(num_drf).rmin = buffer(6)
        drf_par(num_drf).rmax = buffer(7)
        z_center_global         = buffer(8) 
        zmin = z_center_global - buffer(9) / 2.
        zmax = z_center_global + buffer(9) / 2.
        if (drf_par(num_drf).num_anode .gt. 0) then
         if (drf_par(num_drf).zmin .ne. zmin .or.
     &       drf_par(num_drf).zmax .ne. zmax) then
          do i = 1,drf_par(num_drf).num_anode
c
           drf_par(num_drf).an(i).zmin =
     &     drf_par(num_drf).an(i).zmin + z_center_global
           drf_par(num_drf).an(i).zmax =
     &     drf_par(num_drf).an(i).zmax + z_center_global
c
           if (drf_par(num_drf).an(i).eff_hit .eq. 0.) then
            drf_par(num_drf).an(i).eff_hit = buffer(19)
           end if
           if (drf_par(num_drf).an(i).eff_dedx .eq. 0.) then
            drf_par(num_drf).an(i).eff_dedx = buffer(20)
           end if
           if (drf_par(num_drf).an(i).siga .eq. 0.) then
            drf_par(num_drf).an(i).siga = buffer(21)
           end if
           if (drf_par(num_drf).an(i).sigb .eq. 0.) then
            drf_par(num_drf).an(i).sigb = buffer(22)
           end if
           if (drf_par(num_drf).an(i).sigc .eq. 0.) then
            drf_par(num_drf).an(i).sigc = buffer(23)
           end if
c
          end do
         end if
        end if
c
        if (drf_par(num_drf).num_cathode .gt. 0) then
         if (drf_par(num_drf).zmin .ne. zmin .or.
     &       drf_par(num_drf).zmax .ne. zmax) then
          do i = 1,drf_par(num_drf).num_cathode
c
           drf_par(num_drf).cath(i).zmin =
     &     drf_par(num_drf).cath(i).zmin + z_center_global
           drf_par(num_drf).cath(i).zmax =
     &     drf_par(num_drf).cath(i).zmax + z_center_global
c
           if (drf_par(num_drf).cath(i).eff_hit .eq. 0.) then
            drf_par(num_drf).cath(i).eff_hit = buffer(24)
           end if
           if (drf_par(num_drf).cath(i).resa .eq. 0.) then
            drf_par(num_drf).cath(i).resa = buffer(25)
           end if
           if (drf_par(num_drf).cath(i).resb .eq. 0.) then
            drf_par(num_drf).cath(i).resb = buffer(26)
           end if
           if (drf_par(num_drf).cath(i).resc .eq. 0.) then
            drf_par(num_drf).cath(i).resc = buffer(27)
           end if
c
          end do
         end if
        end if
c
        drf_par(num_drf).zmin = zmin
        drf_par(num_drf).zmax = zmax
        do i = 1,4
         drf_par(num_drf).thick_boun(i) = buffer(10+i)
        end do
       end if
c
      end if
c
c
c
      if (keyword .eq. 'LAYERDRFANO') then
c
       i_det = int(buffer(2))
       i_lyr = int(buffer(3))
       if (i_det .gt. max_drf) i_det = max_drf
       if (i_lyr .gt. max_drf_anode) i_lyr = max_drf_anode
c
       if (i_fill .gt. 0) then
c
        drf_par(i_det).an(i_lyr).radius = buffer(4)
        drf_par(i_det).an(i_lyr).zmin = - buffer(5) / 2.
     &  + (drf_par(i_det).zmin + drf_par(i_det).zmax) / 2.
        drf_par(i_det).an(i_lyr).zmax =   buffer(5) / 2.
     &  + (drf_par(i_det).zmin + drf_par(i_det).zmax) / 2.
        drf_par(i_det).an(i_lyr).cell_height = buffer(6)
        drf_par(i_det).an(i_lyr).nwire = int(buffer(7))
        nchan = drf_par(i_det).nchan 
     &        - drf_par(i_det).an(i_lyr).nchan
     &        + int(buffer(7))
        drf_par(i_det).an(i_lyr).nchan = int(buffer(7))
        drf_par(i_det).an(i_lyr).chan0 = 0
        drf_par(i_det).an(i_lyr).cell_phi = tpi / int(buffer(7))
        drf_par(i_det).an(i_lyr).readout  = int(buffer(8))
        drf_par(i_det).an(i_lyr).cathode  = int(buffer(9))
        drf_par(i_det).an(i_lyr).phi0     = buffer(10)
        drf_par(i_det).an(i_lyr).tau      = buffer(11)
        drf_par(i_det).an(i_lyr).stereo_offset = buffer(12)
c
c     Stereo offset and tau can both be used to specify the stereo angle tau.
c     Use following procedure
c     1. If only stereo offset is given, calculate tau from it
c     2. If only tau is given, use it
c     3. If both stereo offset and tau are given, flag it as error
c
c     If stereo_offset is given, radius given is at z = Zmax
c     If stereo_tau    is given, radius given is at z = 0
        stereo = 0
        if(drf_par(i_det).an(i_lyr).stereo_offset .ne. 0.) stereo = 1
        if(drf_par(i_det).an(i_lyr).tau .ne. 0.) stereo = stereo + 2
        if(stereo .eq. 3) then
         write(6,5002) i_det, i_lyr
        end if
        if (stereo .ne. 0.) then
          if(stereo .eq. 1) then     !stereo_offset specified
            x_phi = 
     &      drf_par(i_det).an(i_lyr).stereo_offset * 
     &      drf_par(i_det).an(i_lyr).cell_phi / 2.
            x_tg_tau = 
     &      drf_par(i_det).an(i_lyr).radius * sin(x_phi) / buffer(5)
            drf_par(i_det).an(i_lyr).tant     = x_tg_tau
            drf_par(i_det).an(i_lyr).tau      = atan(x_tg_tau)
            drf_par(i_det).an(i_lyr).rcenter  = 
     &      drf_par(i_det).an(i_lyr).radius * cos(x_phi)
          else                       !stereo_tau specified
            drf_par(i_det).an(i_lyr).tant = 
     &      tan(drf_par(i_det).an(i_lyr).tau)
            tanphi = buffer(5) * drf_par(i_det).an(i_lyr).tant 
     &             / drf_par(i_det).an(i_lyr).radius
            x_phi = atan(tanphi)
            drf_par(i_det).an(i_lyr).stereo_offset = 2.* x_phi 
     &       /  drf_par(i_det).an(i_lyr).cell_phi
            drf_par(i_det).an(i_lyr).rcenter = buffer(4)
            drf_par(i_det).an(i_lyr).radius  = buffer(4) / cos(x_phi)
          endif
          drf_par(i_det).an(i_lyr).lstereo = .true.
        else 
          drf_par(i_det).an(i_lyr).lstereo = .false.
          drf_par(i_det).an(i_lyr).rcenter  = 
     &    drf_par(i_det).an(i_lyr).radius
          drf_par(i_det).an(i_lyr).stereo_offset = 0.
          drf_par(i_det).an(i_lyr).tau = 0.
          drf_par(i_det).an(i_lyr).tant = 0.
        end if
        drf_par(i_det).an(i_lyr).cell_width = 
     &      drf_par(i_det).an(i_lyr).cell_phi 
     &   *  drf_par(i_det).an(i_lyr).rcenter
        if (buffer(13) .ne. 0.) then
         drf_par(i_det).an(i_lyr).eff_hit  = buffer(13)
        end if
        if (buffer(14) .ne. 0.) then
         drf_par(i_det).an(i_lyr).eff_dedx = buffer(14)
        end if
        if (buffer(15) .ne. 0.) then
         drf_par(i_det).an(i_lyr).siga     = buffer(15)
        end if
        if (buffer(16) .ne. 0.) then
         drf_par(i_det).an(i_lyr).sigb     = buffer(16)
        end if
        if (buffer(17) .ne. 0.) then
         drf_par(i_det).an(i_lyr).sigc     = buffer(17)
        end if
c
        drf_par(i_det).nchan = nchan
c
       end if
c
      end if
c
c
c
      if (keyword .eq. 'OFFSETDRFANO') then
c
       i_det = int(buffer(2))
       i_lyr = int(buffer(3))
       if (i_det .gt. max_drf) i_det = max_drf
       if (i_lyr .gt. max_drf_anode) i_lyr = max_drf_anode
c
       if (i_fill .gt. 0) then
        drf_par(i_det).an(i_lyr).cell_offset = buffer(4)
        drf_par(i_det).an(i_lyr).sag         = buffer(5)
        do i = 1,3
         drf_par(i_det).an(i_lyr).offset(i) = buffer(5+i)
         drf_par(i_det).an(i_lyr).dircos(i) = buffer(8+i)
        end do
       end if
c
      end if
c
c
c
      if (keyword .eq. 'LAYERDRFCATHO') then
c
       i_det = int(buffer(2))
       if (i_det .gt. max_drf) i_det = max_drf
       i_lyr = int(buffer(3))
       if (i_lyr .gt. max_drf_cathode) i_lyr = max_drf_cathode
c
       if (i_fill .gt. 0) then
c
        drf_par(i_det).cath(i_lyr).delta_r  = buffer(4)
        drf_par(i_det).cath(i_lyr).zmin     = - buffer(5) / 2.
     &     + (drf_par(i_det).zmin + drf_par(i_det).zmax) / 2.
        drf_par(i_det).cath(i_lyr).zmax     =   buffer(5) / 2.
     &     + (drf_par(i_det).zmin + drf_par(i_det).zmax) / 2.
        drf_par(i_det).cath(i_lyr).nwir_z   = int(buffer(6))
        drf_par(i_det).cath(i_lyr).nwir_phi = int(buffer(7))
        drf_par(i_det).cath(i_lyr).anode    = int(buffer(8))
        drf_par(i_det).cath(i_lyr).cell_offset = buffer(9)
        if (buffer(10) .ne. 0.) then
         drf_par(i_det).cath(i_lyr).eff_hit  = buffer(10)
        end if
        if (buffer(11) .ne. 0.) then
         drf_par(i_det).cath(i_lyr).resa     = buffer(11)
        end if
        if (buffer(12) .ne. 0.) then
         drf_par(i_det).cath(i_lyr).resb     = buffer(12)
        end if
        if (buffer(13) .ne. 0.) then
         drf_par(i_det).cath(i_lyr).resc     = buffer(13)
        end if
c
       end if
c
      end if
c
c
c
      return
c
 5000 format('CENTRAL TRK ', i4, ' : NO MATERIAL')
 5001 format('CENTRAL TRK ', i4, ' : NO MATERIAL AT BOUN. ', i4)
c
 5002 format('  CENTRAL TRK ', i4, ' LAYER ', i4, /,
     *       'You have specified both stereo_offset and stereo_tau ',
     *       'in your drift chamber specification.', /,
     *       'We recommend to use only one of them !', /,
     *       'If both specified, we use stereo_tau.', /,
     *       'Make sure the data you have specified ',
     *       'match each other !', /)
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:35  garren
c add rcs log line
c
