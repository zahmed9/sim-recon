      subroutine load_ftrk
      implicit none
      integer i, j, idet, ily
      real xdim, ydim, thick_total, z_length
      real*8 cell_size, xdead, ydead
      integer lenocc
      external lenocc
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "for_trk.inc"

      ftrk_num = min(max_ftrk,n_obj_ftrk)
      if (ftrk_num.gt.0) then
        write(mcp_llpt,*) 'Loading forward tracking chams'
      endif

      do i=1,ftrk_num
        idet = ftrk(i).det
        ftrk_par(idet).name = ftrk(i).name(:lenocc(ftrk(i).name))
        call getmat(ftrk(i).mat_fill,ftrk_par(idet).material)
        do j=1,6
          call getmat(ftrk(i).mat_boun(j),ftrk_par(idet).mat_boun(j))
          ftrk_par(idet).thick_boun(j) = ftrk(i).thick_boun(j)
        enddo
        ftrk_par(idet).nlyr = min(max_ftrk_lyr,ftrk(i).nlyr)
        ftrk_par(idet).xmin = ftrk(i).xmin
        ftrk_par(idet).xmax = ftrk(i).xmax
        ftrk_par(idet).ymin = ftrk(i).ymin
        ftrk_par(idet).ymax = ftrk(i).ymax
        ftrk_par(idet).zmin = ftrk(i).z0 - ftrk(i).zlen/2.
        ftrk_par(idet).zmax = ftrk(i).z0 + ftrk(i).zlen/2.
        ftrk_par(idet).nchan = 0
      enddo

      do i=1,n_obj_layerftrk
        idet = min(max_ftrk,layerftrk(i).det)
        ily = min(max_ftrk_lyr,layerftrk(i).lyr)

        ftrk_par(idet).lyr(ily).xmin = layerftrk(i).xmin
        ftrk_par(idet).lyr(ily).xmax = layerftrk(i).xmax
        ftrk_par(idet).lyr(ily).xmin_gap = layerftrk(i).xmin_gap
        ftrk_par(idet).lyr(ily).xmax_gap = layerftrk(i).xmax_gap
        ftrk_par(idet).lyr(ily).ymin = layerftrk(i).ymin
        ftrk_par(idet).lyr(ily).ymax = layerftrk(i).ymax
        ftrk_par(idet).lyr(ily).ymin_gap = layerftrk(i).ymin_gap
        ftrk_par(idet).lyr(ily).ymax_gap = layerftrk(i).ymax_gap
        ftrk_par(idet).lyr(ily).z = layerftrk(i).z_local
     &    + .5*(ftrk_par(idet).zmin+ftrk_par(idet).zmax)
        ftrk_par(idet).lyr(ily).thickness  = layerftrk(i).thick
        ftrk_par(idet).lyr(ily).stereo     = layerftrk(i).stereo
        ftrk_par(idet).lyr(ily).cos_stereo = cos(layerftrk(i).stereo)
        ftrk_par(idet).lyr(ily).sin_stereo = sin(layerftrk(i).stereo)
        ftrk_par(idet).nchan = ftrk_par(idet).nchan + layerftrk(i).ncell
        ftrk_par(idet).lyr(ily).ncell    = layerftrk(i).ncell
        ftrk_par(idet).lyr(ily).coord0_x = layerftrk(i).coord0_x
        ftrk_par(idet).lyr(ily).coord0_y = layerftrk(i).coord0_y
c
c   Calculate cell size assuming that the dead area is symmetric.
c
        xdead = ftrk_par(idet).lyr(ily).coord0_x -
     +          ftrk_par(idet).lyr(ily).xmin
        ydead = ftrk_par(idet).lyr(ily).coord0_y -
     +          ftrk_par(idet).lyr(ily).ymin
        xdim  = ftrk_par(idet).lyr(ily).xmax - 
     +          ftrk_par(idet).lyr(ily).xmin - 2.*xdead
        ydim  = ftrk_par(idet).lyr(ily).ymax - 
     +          ftrk_par(idet).lyr(ily).ymin - 2.*ydead

        if ( layerftrk(i).type .eq. 2 ) then
           cell_size = xdim/ftrk_par(idet).lyr(ily).ncell

        else if ( layerftrk(i).type .eq. 3 ) then
           cell_size = ydim/ftrk_par(idet).lyr(ily).ncell

        else
            cell_size = (xdim*abs(ftrk_par(idet).lyr(ily).sin_stereo) +
     +                   ydim*abs(ftrk_par(idet).lyr(ily).cos_stereo) )/
     +                  ftrk_par(idet).lyr(ily).ncell
        endif
        ftrk_par(idet).lyr(ily).cell_size = cell_size
        ftrk_par(idet).lyr(ily).type     = layerftrk(i).type
        ftrk_par(idet).lyr(ily).eff_hit  = layerftrk(i).eff_hit
        ftrk_par(idet).lyr(ily).siga  = layerftrk(i).siga
        ftrk_par(idet).lyr(ily).sigb  = layerftrk(i).sigb
        ftrk_par(idet).lyr(ily).sigc  = layerftrk(i).sigc
      enddo

      do j=1,ftrk_num
        idet = ftrk(j).det
        if (ftrk_par(idet).zmin .ne. 0. .and.
     +    ftrk_par(idet).zmax .ne. 0. .and.
     +    ftrk_par(idet).nlyr .gt. 0) then
          thick_total = 0.
          do i = 1,ftrk_par(idet).nlyr
            thick_total = thick_total 
     &        + ftrk_par(idet).lyr(i).thickness
          end do
          z_length = ftrk_par(idet).zmax 
     &      - ftrk_par(idet).zmin
          if (thick_total .gt. z_length) then
            write(mcp_llpt, 6000) idet,thick_total,ftrk_par(idet).nlyr,
     &        z_length
 6000       format('FORW. TRK. ', i4, ' : overall length ', f10.4, 
     &        ' required for ', i4, 
     &        ' layers of thickness you have specified', /,
     &        ' overall length ',f10.4,' specified is not big enough')
            stop
          end if
        end if
        write(mcp_llpt,'(a,i4,i7,4f9.3)') '   FTrk '//
     +    ftrk_par(idet).name(:lenocc(ftrk_par(idet).name))//
     +    '  nly,nch,xmin,xmax,zmin,zmax ',
     +    ftrk_par(idet).nlyr,ftrk_par(idet).nchan,
     +    ftrk_par(idet).xmin,ftrk_par(idet).xmax,
     +    ftrk_par(idet).zmin,ftrk_par(idet).zmax
      enddo

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.6  2000/01/26 00:42:18  kutschke
c Compute cell_size properly.  Add types 2 and 3.
c
c Revision 1.5  1999/03/16  23:48:23  kutschke
c Fix bug in cell_size.
c
c Revision 1.4  1997/04/04  20:29:50  garren
c add rcs log line
c
