      logical function dtf_open(type)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Returns TRUE if a dataset of the specified type is currently being
c  read, and FALSE if it is not.
c
c  type    integer variable (read)
c          1 for signal dataset, 2 for background dataset
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "input_files.inc"

c     calling arguments
      integer type
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dtf_open = .FALSE.

      if(type .eq. 1) then
        if(dtf_sig_current .gt. 0) dtf_open = .TRUE.
      else
        if(dtf_back_current .gt. 0) dtf_open = .TRUE.
      endif

c     Normal exit
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:10  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:29  garren
c add rcs log line
c
