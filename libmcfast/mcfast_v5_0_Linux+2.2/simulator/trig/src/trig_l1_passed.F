      subroutine trig_l1_passed(l1_passed, marked)
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : did any level 1 trigger pass
C-
C-   returned value: true if any USE trigger passed, or if no USE triggers
C-                   programmed
C-                   
C-   Inputs  : 
C-   Outputs : l1_passed--true if any USE trigger passed or if no USED triggers
C-                        available
C-             marked-- true if USE trigger was part of the decision
C-                   -- false if no USE triggers
C-   Controls:
C-
C-   Created   5-APR-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
      implicit none
#include "trig_term_struct.inc"
#include "trig_bit_struct.inc"
#include "trig_l1_bits.inc"
      integer itrig, used
c returned variables
      logical l1_passed, marked
C----------------------------------------------------------------------

      l1_passed = .false.
      marked         = .false.
      used           = 0      
      do itrig = 0,l1trig_bits_max-1
         if( trig_l1_bits(itrig).use_trigger)then
           marked = .true.
           used = used + 1
           if(trig_l1_bits(itrig).trig_fired.eq.1) then
             l1_passed = .true.
             goto 999  !you got what you wanted, so leave
           endif
         endif
      enddo   
      if (used .eq. 0) l1_passed = .true.   
  999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:42  garren
c add rcs log line
c
