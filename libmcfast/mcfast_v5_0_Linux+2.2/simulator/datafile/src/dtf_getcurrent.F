      subroutine dtf_getcurrent(temp, type)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Returns the current dataset
c
c *temp    dataset structure (write)
c          name of dataset
c
c  type    integer variable (read)
c          1 for signal dataset, 2 for background dataset
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "dataset.inc"
#include "input_files.inc"

c     calling arguments
      record /dataset/ temp
      integer type
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(type .eq. 1) then
        if(dtf_sig_current .eq. 0) goto 9999
        temp.file = dtf_sig(dtf_sig_current).file
        temp.events = dtf_sig(dtf_sig_current).events
        temp.anal = dtf_sig(dtf_sig_current).anal
        temp.sigma = dtf_sig(dtf_sig_current).sigma
        temp.active = dtf_sig(dtf_sig_current).active
      else
        if(dtf_back_current .eq. 0) goto 9999
        temp.file = dtf_back(dtf_back_current).file
        temp.events = dtf_back(dtf_back_current).events
        temp.anal = dtf_back(dtf_back_current).anal
        temp.sigma = dtf_back(dtf_back_current).sigma
        temp.active = dtf_back(dtf_back_current).active
      endif

c     Normal exit
      return

c     Error exit
9999  continue
      temp.file = ' '
      temp.events = 0
      temp.anal = 0
      temp.sigma = 0.
      temp.active = 0
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:09  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:27  garren
c add rcs log line
c
