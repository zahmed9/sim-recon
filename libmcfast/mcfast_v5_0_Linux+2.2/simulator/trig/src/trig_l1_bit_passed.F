      function trig_l1_bit_passed(ibit)
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : sets trigger bit number
C-
C-   Inputs  : ibit -- bit number
C-   Outputs : returns true if the trigger bit was set
C-   Controls:
C-
C-   Created   1-APR-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
      implicit none
#include "trig_term_struct.inc"
#include "trig_bit_struct.inc"
#include "trig_l1_bits.inc"
      integer ibit
      logical trig_l1_bit_passed
C----------------------------------------------------------------------

      trig_l1_bit_passed = .false.

      if(trig_l1_bits(ibit).trig_fired.eq.1)
     &   trig_l1_bit_passed = .true.
      
  999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:40  garren
c add rcs log line
c
