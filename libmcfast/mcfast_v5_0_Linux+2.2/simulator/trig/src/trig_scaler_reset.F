      subroutine trig_scaler_reset()
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : resets number of events tried and passed for
C-                         trigger terms and bits
C-
C-   Inputs  : none
C-   Outputs : none
C-   Controls:
C-
C-   Created  23-Mar-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
      implicit none
#include "trig_term_index.params"
#include "trig_l1_terms.params"
#include "trig_l2_terms.params"
#include "trig_term_struct.inc"
#include "trig_bit_struct.inc"
#include "trig_l1_bits.inc"
#include "trig_l1_terms.inc"
#include "trig_l2_bits.inc"
#include "trig_l2_terms.inc"

c     local variables
      integer ibit, iterm
    
      do ibit = 0, l1trig_bits_max - 1
        trig_l1_bits(ibit).nevt_passed =  0
        trig_l1_bits(ibit).nevt_tried = 0
      enddo
      do ibit = 0, l2trig_bits_max - 1
        trig_l2_bits(ibit).nevt_passed = 0
        trig_l2_bits(ibit).nevt_tried = 0
      enddo
      do iterm = 1, nandor_terms_max
        trig_l1_terms(iterm).nevt_tried = 0
        trig_l1_terms(iterm).nevt_passed = 0
      enddo
      do iterm = 1, nandor_terms_max
        trig_l2_terms(iterm).nevt_tried = 0
        trig_l2_terms(iterm).nevt_passed = 0
      enddo       
 999  return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:51  garren
c add rcs log line
c
