      subroutine hwg_user_reset
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Author: Paul Avery  3-7-94
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "herwig61.inc"
#include "herwig_cmd.inc"

c     Local variables
      character command*15
      integer i
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      do i=1,nstring_list
        
        command = string_list(i)

c     "ranseed"
        if(command .eq. 'ranseed') then
          nrn(1) = ival_string(1,i)
          nrn(2) = ival_string(2,i)

c     "ptmin"
        else if(command .eq. 'ptmin') then
          ptmin = val_string(1,i)

c     "ptmax"
        else if(command .eq. 'ptmax') then
          ptmax = val_string(1,i)

c     "yjmin"
        else if(command .eq. 'yjmin') then
          yjmin = val_string(1,i)

c     "yjmax"
        else if(command .eq. 'yjmax') then
          yjmax = val_string(1,i)

c     "qcdlam"
        else if(command .eq. 'qcdlam') then
          qcdlam = val_string(1,i)

c     "rmass"
        else if(command .eq. 'rmass') then
          rmass(ival_string(1,i)) = val_string(2,i)

c     "maxpr"
        else if(command .eq. 'maxpr') then
          maxpr = ival_string(1,i)

        endif

      enddo

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.5  2000/01/26 02:51:45  bphyslib
c use herwig61.inc
c
c Revision 1.4  1998/07/09  21:00:22  garren
c for lund v6_115, herwig v5_9a, and isajet v7_37
c
c Revision 1.3  1998/06/25  15:49:00  bphyslib
c add all necessary changes from v3_3
c
