      subroutine load_drift
      implicit none
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "drift.inc"
#include "const.inc"
      integer i,j,ia,idet,ily,nchan,stereo,nwires
      real tanphi,x_phi,x_tg_tau

      integer num_anode_total 

      integer lenocc
      external lenocc
*
      drf_num = min(max_drf,n_obj_drift)
      if (drf_num.gt.0) then
        write(mcp_llpt,*) 'Loading drift chams'
      endif

      num_anode_total = 0

      do i=1,drf_num
        drf_par(i).name = drift(i).name(:lenocc(drift(i).name))
        drf_par(i).nchan = 0
        call getmat(drift(i).material,drf_par(i).material)
        do j=1,4
          drf_par(i).thick_boun(j) = drift(i).thick_boun(j)
          call getmat(drift(i).mat_boun(j),drf_par(i).mat_boun(j))
        enddo
        drf_par(i).num_anode = min(drift(i).num_anode,max_drf_anode)
        drf_par(i).num_cathode = min(drift(i).num_cathode,
     +    max_drf_cathode)
        drf_par(i).rmin = drift(i).rmin
        drf_par(i).rmax = drift(i).rmax
        drf_par(i).zmin = drift(i).z0 - drift(i).zlen/2.
        drf_par(i).zmax = drift(i).z0 + drift(i).zlen/2.
*         
        num_anode_total = num_anode_total + drift(i).num_anode

      enddo

      if (num_anode_total.lt.n_obj_layerdrfano) then
            write(mcp_llpt,1000) n_obj_layerdrfano,drift(i).num_anode
 1000       format('LOAD_DRIFT ERROR: Not enough anode planes in db',
     +             2i5)
      endif
      if (num_anode_total.lt.n_obj_offsetdrfano) then
            write(mcp_llpt,1001) n_obj_offsetdrfano,drift(i).num_anode
 1001       format('LOAD_DRIFT ERROR: Not enough anode offsets in db',
     +             2i5)
      endif

*
***     Install anode layers
      do i=1,n_obj_layerdrfano
        idet = min(layerdrfano(i).det,max_drf)
        ily  = min(layerdrfano(i).lyr,max_drf_anode)
        if (idet.gt.drf_num) then
          write(mcp_llpt,1002) idet,drf_num
 1002     format('LOAD_DRIFT ERROR: Anode idet bigger than Ndets',
     +      2i5)
        endif

        drf_par(idet).an(ily).radius = layerdrfano(i).radius
        drf_par(idet).an(ily).zmin = -layerdrfano(i).zlen/2. +
     +    (drf_par(idet).zmin+drf_par(idet).zmax)/2.
        drf_par(idet).an(ily).zmax = layerdrfano(i).zlen/2. +
     +    (drf_par(idet).zmin+drf_par(idet).zmax)/2.
        drf_par(idet).an(ily).cell_height = layerdrfano(i).cell_height
        drf_par(idet).an(ily).nwire = layerdrfano(i).nwires
        drf_par(idet).nchan = drf_par(idet).nchan+layerdrfano(i).nwires
        drf_par(idet).an(ily).nchan = layerdrfano(i).nwires
        drf_par(idet).an(ily).chan0 = 0
        drf_par(idet).an(ily).cell_phi = tpi/layerdrfano(i).nwires
        drf_par(idet).an(ily).readout = layerdrfano(i).id_readout
        drf_par(idet).an(ily).cathode = layerdrfano(i).id_cathode
        drf_par(idet).an(ily).phi0 = layerdrfano(i).phi0
        drf_par(idet).an(ily).tau = layerdrfano(i).stereo_tau
        drf_par(idet).an(ily).stereo_offset =
     +    layerdrfano(i).stereo_offset
c
c     Stereo offset and tau can both be used to specify the stereo angle tau.
c     Use following procedure
c     1. If only stereo offset is given, calculate tau from it
c     2. If only tau is given, use it
c     3. If both stereo offset and tau are given, flag it as error
c
c     If stereo_offset is given, radius given is at z = Zmax
c     If stereo_tau    is given, radius given is at z = 0
c
        stereo = 0
        if(drf_par(idet).an(ily).stereo_offset .ne. 0.) stereo = 1
        if(drf_par(idet).an(ily).tau .ne. 0.) stereo = stereo + 2
        if(stereo .eq. 3) then
          write(6,5002) idet, ily
 5002     format('  CENTRAL TRK ', i4, ' LAYER ', i4, /,
     *       'You have specified both stereo_offset and stereo_tau ',
     *       'in your drift chamber specification.', /,
     *       'We recommend to use only one of them !', /,
     *       'If both specified, we use stereo_tau.', /,
     *       'Make sure the data you have specified ',
     *       'match each other !', /)
        end if
        if (stereo .ne. 0.) then
          if(stereo .eq. 1) then !stereo_offset specified
            x_phi = drf_par(idet).an(ily).stereo_offset * 
     &        drf_par(idet).an(ily).cell_phi / 2.
            x_tg_tau = 
     &        drf_par(idet).an(ily).radius * sin(x_phi) /
     +        layerdrfano(i).zlen
            drf_par(idet).an(ily).tant     = x_tg_tau
            drf_par(idet).an(ily).tau      = atan(x_tg_tau)
            drf_par(idet).an(ily).rcenter  = 
     &        drf_par(idet).an(ily).radius * cos(x_phi)
          else                  !stereo_tau specified
            drf_par(idet).an(ily).tant = 
     &        tan(drf_par(idet).an(ily).tau)
            tanphi = layerdrfano(i).zlen * drf_par(idet).an(ily).tant
     &        / drf_par(idet).an(ily).radius
            x_phi = atan(tanphi)
            drf_par(idet).an(ily).stereo_offset = 2.* x_phi 
     &        /  drf_par(idet).an(ily).cell_phi
            drf_par(idet).an(ily).rcenter = layerdrfano(i).radius
            drf_par(idet).an(ily).radius  = layerdrfano(i).radius
     +        / cos(x_phi)
          endif
          drf_par(idet).an(ily).lstereo = .true.
        else 
          drf_par(idet).an(ily).lstereo = .false.
          drf_par(idet).an(ily).rcenter  = 
     &      drf_par(idet).an(ily).radius
          drf_par(idet).an(ily).stereo_offset = 0.
          drf_par(idet).an(ily).tau = 0.
          drf_par(idet).an(ily).tant = 0.
        end if
        drf_par(idet).an(ily).cell_width = 
     &    drf_par(idet).an(ily).cell_phi 
     &    *  drf_par(idet).an(ily).rcenter
        drf_par(idet).an(ily).eff_hit  = layerdrfano(i).eff_hit
        drf_par(idet).an(ily).eff_dedx = layerdrfano(i).eff_dedx
        drf_par(idet).an(ily).siga = layerdrfano(i).siga
        drf_par(idet).an(ily).sigb = layerdrfano(i).sigb
        drf_par(idet).an(ily).sigc = layerdrfano(i).sigc
      enddo
*
***     handle anode offsets
      do i=1,n_obj_offsetdrfano
        idet = min(offsetdrfano(i).det,max_drf)
        ily  = min(offsetdrfano(i).lyr,max_drf_anode)
        if (idet.gt.drf_num) then
          write(mcp_llpt,1003) idet,drf_num
 1003     format('LOAD_DRIFT ERROR: Offset idet bigger than Ndets',
     +      2i5)
        endif

        drf_par(idet).an(ily).cell_offset = offsetdrfano(i).cell_offset
        drf_par(idet).an(ily).sag = offsetdrfano(i).sag
        do j=1,3
          drf_par(idet).an(ily).offset(j) = offsetdrfano(i).offset(j)
          drf_par(idet).an(ily).dircos(j) = offsetdrfano(i).dircos(j)
        enddo
      enddo
*
***     Install cathode layers
      do i=1,n_obj_layerdrfcatho
        idet = min(layerdrfcatho(i).det,max_drf)
        ily  = min(layerdrfcatho(i).lyr,max_drf_cathode)
        if (idet.gt.drf_num) then
          write(mcp_llpt,1004) idet,drf_num
 1004     format('LOAD_DRIFT ERROR: Cathode idet bigger than Ndets',
     +      2i5)
        endif

        drf_par(idet).cath(ily).delta_r = layerdrfcatho(i).delta_r
        drf_par(idet).cath(ily).zmin = -layerdrfcatho(i).zlen/2.
     +    + (drf_par(idet).zmin + drf_par(idet).zmax) / 2.
        drf_par(idet).cath(ily).zmax = layerdrfcatho(i).zlen/2.
     +    + (drf_par(idet).zmin + drf_par(idet).zmax) / 2.
        drf_par(idet).cath(ily).nwir_z = layerdrfcatho(i).nstrips
        drf_par(idet).cath(ily).nwir_phi = layerdrfcatho(i).n_phi_segm
        drf_par(idet).cath(ily).anode = layerdrfcatho(i).id_anode
        drf_par(idet).cath(ily).cell_offset = 
     +    layerdrfcatho(i).cell_offset
        drf_par(idet).cath(ily).eff_hit = layerdrfcatho(i).eff_hit
        drf_par(idet).cath(ily).resa = layerdrfcatho(i).resa
        drf_par(idet).cath(ily).resb = layerdrfcatho(i).resb
        drf_par(idet).cath(ily).resc = layerdrfcatho(i).resc
      enddo

      do i=1,drf_num
        write(mcp_llpt,'(a,i5,2i4,4f9.3)') '   Dcham '//
     +    drf_par(i).name(:lenocc(drf_par(i).name))//
     +    ' nch, nA, nC, rmin, rmax, zmin, zmax',
     +    drf_par(i).nchan,drf_par(i).num_anode,drf_par(i).num_cathode,
     +    drf_par(i).rmin,drf_par(i).rmax,drf_par(i).zmin,
     +    drf_par(i).zmax
      enddo

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.5  1998/10/13 21:59:37  yarba_j
c minor cleanup
c
c Revision 1.4  1998/10/13  21:57:53  yarba_j
c  fixed confusing error message
c
c Revision 1.3  1997/04/04  20:29:49  garren
c add rcs log line
c
