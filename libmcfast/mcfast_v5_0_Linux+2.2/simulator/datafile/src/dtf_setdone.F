      subroutine dtf_setdone(type)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Set a flag saying that we are finished reading the current dataset
c
c  type    integer variable (read)
c          1 = signal dataset, 2 = background dataset
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "dataset.inc"
#include "input_files.inc"

c     calling arguments
      integer type

c     local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(type .eq. 1) then
        dtf_sig(dtf_sig_current).anal = 1
      else
        dtf_back(dtf_back_current).anal = 1
      endif

c     normal exit
1000  return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:10  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:29  garren
c add rcs log line
c
