      subroutine trig_summary(lun)
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : Prints trigger programming and output summary to
C-                         a logical unit
C-
C-   Inputs  : lun - logical unit number
C-   Outputs :
C-   Controls:
C-
C-   Created   4-MAR-1994   Amber S. Boehnlein
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
      integer lun
      integer iterm_type,iterm,index,i,itrig
C----------------------------------------------------------------------
      write (lun,*) ' Trigger Programming Summary'
      write (lun,*) ' ***************************'
      write (lun,*) ' level 1 term definitions'
      write (lun,115)
  115 format(3x' TERM',12x,'TERM NAME',25x,' events passed / tried')
      write (lun,*)
     &  '----------------------------------------------------------'

C
C ****  loop over the used terms
C
      do iterm_type = 1 , nterm_type
        do iterm = 0, l1_nterm_used(iterm_type)-1
          index = l1_first_term(iterm_type) + iterm
          write( lun,120 )trig_l1_terms(index).term_number,
     &      trig_l1_terms(index).term_name,
     &      trig_l1_terms(index).nevt_passed,
     &      trig_l1_terms(index).nevt_tried
  120       format(5x,i3,5x,a40,5x,i8,'/',i8)
        enddo
      enddo
c
      write (lun,*)
      write (lun,*) 'LEVEL 1 specific triggers'
      write (lun,*)
      do itrig = 0,l1trig_bits_max-1
         if (trig_l1_bits(itrig).trig_bit.eq.itrig) then
           if (trig_l1_bits(itrig).use_trigger) then
            write(lun, 200) trig_l1_bits(itrig).trig_bit,
     &        trig_l1_bits(itrig).trig_name,
     &        trig_l1_bits(itrig).nevt_passed,
     &        trig_l1_bits(itrig).nevt_tried
           else
            write(lun, 205) trig_l1_bits(itrig).trig_bit,
     &        trig_l1_bits(itrig).trig_name,
     &        trig_l1_bits(itrig).nevt_passed,
     &        trig_l1_bits(itrig).nevt_tried
           endif
  200         format(' Trigger', i2, 2x, a,2x,'required',6x,i8,'/',i8)
  205         format(' Trigger', i2, 2x, a,2x,'not required',3x
     &                 ,i8,'/',i8)
            write(lun, 210) (trig_l1_bits(itrig).trig_andor(i), i = 1,
     &        trig_l1_bits(itrig).trig_nterms)
  210       format(3x ' terms used:', 10(i3,1x), ' ]')
            write(lun,*)
         else
            write( lun, 300) itrig
  300       format(3x' Trigger bit ', i2, ' not programmed')
          endif
      enddo
  999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:51  garren
c add rcs log line
c
