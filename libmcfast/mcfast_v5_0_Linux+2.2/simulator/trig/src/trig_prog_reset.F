      subroutine trig_prog_reset()
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
        trig_l1_bits(ibit).trig_bit = -999
        trig_l1_bits(ibit).trig_name = ' '
        trig_l1_bits(ibit).use_trigger = .false.
        trig_l1_bits(ibit).ref_bit = 0
        trig_l1_bits(ibit).trig_nterms = 0
        do iterm = 1, nandor_terms_max 
          trig_l1_bits(ibit).trig_andor(iterm) = 0
          trig_l1_bits(ibit).trig_andor_polarity(iterm) = 0 
        enddo
      enddo
      do ibit = 0, l2trig_bits_max - 1
        trig_l2_bits(ibit).trig_bit =  -999
        trig_l2_bits(ibit).trig_name = ' '
        trig_l2_bits(ibit).use_trigger = .false.
        trig_l1_bits(ibit).trig_nterms = 0
        trig_l2_bits(ibit).ref_bit = 0
        do iterm = 1, nandor_terms_max 
          trig_l2_bits(ibit).trig_andor(iterm) = 0
          trig_l2_bits(ibit).trig_andor_polarity(iterm) = 0  
        enddo
      enddo
      do iterm = 1, nandor_terms_max
       trig_l1_terms(iterm).term_number = 0
       trig_l1_terms(iterm).term_name =   ' '
       trig_l1_terms(iterm).term_set = 0
       trig_l1_terms(iterm).term_fired = 0
       trig_l1_terms(iterm).threshold = 0.0
       trig_l1_terms(iterm).multiplicity = 0
       trig_l1_terms(iterm).eta_min = 0.0
       trig_l1_terms(iterm).eta_max = 0.0
       trig_l1_terms(iterm).phi_min = 0.0
       trig_l1_terms(iterm).phi_max = 0.0
      enddo
      do iterm = 1, nandor_terms_max 
       trig_l2_terms(iterm).term_number = 0
       trig_l2_terms(iterm).term_name =   ' '
       trig_l2_terms(iterm).term_set = 0
       trig_l2_terms(iterm).term_fired = 0
       trig_l2_terms(iterm).threshold = 0.0
       trig_l2_terms(iterm).multiplicity = 0
       trig_l2_terms(iterm).eta_min = 0.0
       trig_l2_terms(iterm).eta_max = 0.0
       trig_l2_terms(iterm).phi_min = 0.0
       trig_l2_terms(iterm).phi_max = 0.0
      enddo    
 999  return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:50  garren
c add rcs log line
c
