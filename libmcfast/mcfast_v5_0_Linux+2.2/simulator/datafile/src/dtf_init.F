      subroutine dtf_init

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Initialize all data sets
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "dataset.inc"
#include "input_files.inc"

C     Calling arguments

C     Local variables
      integer i

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dtf_numsig = 0
      dtf_sig_current = 0
      do i=1,dtf_maxsig
        dtf_sig(i).file = ' '
        dtf_sig(i).anal = 0
        dtf_sig(i).events = 0
        dtf_sig(i).sigma = 0.
        dtf_sig(i).active = 0
      enddo

      dtf_numback = 0
      dtf_back_current = 0
      do i=1,dtf_maxback
        dtf_back(i).file = ' '
        dtf_back(i).anal = 0
        dtf_back(i).events = 0
        dtf_back(i).sigma = 0.
        dtf_back(i).active = 0
      enddo

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
