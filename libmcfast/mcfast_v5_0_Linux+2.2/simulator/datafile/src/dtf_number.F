      subroutine dtf_number(type, num)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Returns TRUE if a dataset of the specified type is currently being
c  read, and FALSE if it is not.
c
c  type    integer variable (read)
c          1 for signal dataset, 2 for background dataset
c
c *num     integer variable (write)
c          Number of datasets present
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "input_files.inc"

c     calling arguments
      integer type, num
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(type .eq. 1) then
        num = dtf_numsig
      else
        num = dtf_numback
      endif

c     Normal exit
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:10  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:28  garren
c add rcs log line
c
