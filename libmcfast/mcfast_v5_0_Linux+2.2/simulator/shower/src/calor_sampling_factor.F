
      real function calor_sampling_factor(mat, act_mat)

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c     Author : Julia Yarba, FNAL/CD
c              8-7-96
c     Calculates visible fraction of energy for a sampling calorimeter     
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "material.inc"

c     Calling arguments :
      integer mat, act_mat

c     Local variables :
      integer i

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>      

      calor_sampling_factor = 1.

      if (act_mat .gt. 0 .and. act_mat .le. mtl_num .and.
     *    act_mat .ne. mat) then
       do i = 1,max_mat_mix
        if (act_mat .eq. mtl_par(mat).id(i)) then
         goto 1
        end if
       end do
   1   calor_sampling_factor = mtl_par(act_mat).density
     *                       * mtl_par(mat).ratio(i)
     *                       / mtl_par(mat).density
      end if

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:27  eugenio
c Initial revision
c
c Revision 1.4  1997/09/04 22:28:34  bphyslib
c make it better for parsing
c
c Revision 1.3  1997/04/04  20:30:07  garren
c add rcs log line
c
