      subroutine trig_l1_bit_set()
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : sets trigger bit number
C-
C-   Inputs  : none
C-   Outputs : none
C-   Controls:
C-
C-   Created   28-MAR-1994   Amber S. Boehnlein
c-   Loop over all possible trigger bits
C-   Loop over all terms for each trigger bit
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
      integer nterm,iterm,itrig
      integer polarity
      integer set
      parameter (set = 1)
C----------------------------------------------------------------------

      do itrig = 0,l1trig_bits_max-1

         if (trig_l1_bits(itrig).trig_bit.eq.itrig) then
           trig_l1_bits(itrig).trig_fired = 1
           trig_l1_bits(itrig).nevt_tried =
     &          trig_l1_bits(itrig).nevt_tried + 1

           do iterm = 1, trig_l1_bits(itrig).trig_nterms
              nterm    = trig_l1_bits(itrig).trig_andor(iterm)
              polarity = trig_l1_bits(itrig).trig_andor_polarity(iterm)

              if( trig_l1_terms(nterm).term_set.eq.set) then
                 if(trig_l1_terms(nterm).term_fired.ne.polarity)
     &            trig_l1_bits(itrig).trig_fired = 0
              else
                write(6,*) "Error--term required was not set!"
                trig_l1_bits(itrig).trig_fired = 0
              endif
           enddo
         else
           trig_l1_bits(itrig).trig_fired = 0
         endif
         if(trig_l1_bits(itrig).trig_fired.eq.1) 
     &     trig_l1_bits(itrig).nevt_passed = 
     &        trig_l1_bits(itrig).nevt_passed + 1
      enddo
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
