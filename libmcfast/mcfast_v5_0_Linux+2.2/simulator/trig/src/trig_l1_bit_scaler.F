      subroutine trig_l1_bit_scaler(ibit,ntried,npassed)
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : return statisics about a particular 
C-                         level 1 trigger
C-
C-   Inputs  : ibit - trigger bit of interest
C-   Outputs : ntried -- the number of events tried against this trigger
C-             npassed -- the number of events that passed this trigger
C-   Controls:
C-
C-   Created   28-MAR-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
      implicit none
#include "trig_term_struct.inc"
#include "trig_bit_struct.inc"
#include "trig_l1_bits.inc"
c input variables
      integer ibit
c  output variables
      integer ntried,npassed      

C----------------------------------------------------------------------
      ntried = trig_l1_bits(ibit).nevt_tried 
      npassed = trig_l1_bits(ibit).nevt_passed 
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
