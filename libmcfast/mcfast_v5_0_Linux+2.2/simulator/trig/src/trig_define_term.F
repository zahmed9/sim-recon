      subroutine trig_define_term(line,bitnumber,level,ier)
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : Define specific terms.  This routine parses enough
C-                         of the string to determine term type, and passes
C-                         off to a more specific routine for each term type
C-
C-   Inputs  : line --input ling for parsing
C-             bitnumber -- trigger bit associated with this term
C-             level     -- the trigger level
C-   Outputs : error code IER
C-   Controls:
C-
C-   Created  26-FEB-1994   Amber S. Boehnlein
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
C     input variables

      character*(*) line
      integer bitnumber,level
C
      integer term_type
      integer multiplicity
      real eta_min,eta_max,phi_min,phi_max
      real impact_min, impact_max
      real threshold
      integer ier
      integer value
      integer last_bitnumber, iterm
      integer nterms_bit
      integer last_level
      integer polarity

c     character string handling variables
      integer list_num
      parameter (list_num = 14)
      integer list_type(list_num), list_read, list_item(list_num)
      character*10 clist_item(list_num)
c     the line will have the form "l1 term termtype polarity"
c                                   1   2     3     4
c                                   c   c     c     c
      data list_type                /0, 0,    0,    0, 10*0/


      save last_bitnumber
      save nterms_bit
      save last_level
      logical first
      data first /.true./
C----------------------------------------------------------------------
      if(first) then
        last_bitnumber = 999
        nterms_bit =0
        first = .false.
      endif
      ier = 0  !start be assuming all is well
c     Where there problems with trigger bit?
      if(bitnumber.lt.0) then
         ier = -1
         return
      endif
c     Are we on the same trigger bit?
      if(bitnumber.ne.last_bitnumber.or.level.ne.last_level)then
        last_bitnumber = bitnumber
        last_level     = level
        nterms_bit = 0
      endif

      call cmd_getitems(line, list_num, list_type,
     *                        list_read, list_item, clist_item, ier)
!     put some error handling here
c   find out if the term is to be required or vetod
      polarity = 0
      call cmd_upcase(clist_item(4),clist_item(4))
      if(clist_item(4).eq.'REQUIRE') then
         polarity = 1
      elseif(clist_item(4).eq.'VETO') then
         polarity = 0
      else
         print *, ' undefined request for term, veto is used'
      endif
      call trig_get_term_type(clist_item(3),term_type,ier)
!      if (ier.lt.0) call errmsg()

      if (term_type.eq.vertex) then
        call trig_get_disp_v(line,threshold,ier)
        eta_min = 0.0
        eta_max = 0.0
        phi_min = 0.0
        phi_max = 0.0
        multiplicity = 0

      elseif (term_type.eq.fangl) then
        call trig_get_fangle(line,multiplicity,threshold,impact_min,
     &    impact_max,ier)
        eta_min = impact_min !store impact parameters in eta slots
        eta_max = impact_max
        phi_min = 0.0
        phi_max = 0.0
      else
        call trig_get_pt_threshold(line,multiplicity,threshold,
     &    eta_min,eta_max,phi_min,phi_max,ier)
      endif
      if(level.eq.level1) then   !level1 specific trigger
       l1_nterm_used(term_type) = l1_nterm_used(term_type)+1
       nterms_bit = nterms_bit+1
       iterm = l1_nterm_used(term_type)+l1_first_term(term_type) - 1

       trig_l1_terms(iterm).term_number = iterm
       trig_l1_terms(iterm).term_name =   line
       trig_l1_terms(iterm).threshold = threshold
       trig_l1_terms(iterm).multiplicity = multiplicity
       trig_l1_terms(iterm).eta_min = eta_min
       trig_l1_terms(iterm).eta_max = eta_max
       trig_l1_terms(iterm).phi_min = phi_min
       trig_l1_terms(iterm).phi_max = phi_max

       trig_l1_bits(bitnumber).trig_andor(nterms_bit) = iterm
       trig_l1_bits(bitnumber).trig_andor_polarity(nterms_bit)
     &  = polarity
       trig_l1_bits(bitnumber).trig_nterms = nterms_bit

      elseif (level.eq.level2) then  !level2 specific trigger

       l2_nterm_used(term_type) = l2_nterm_used(term_type)+1
       nterms_bit = nterms_bit+1
       iterm = l2_nterm_used(term_type)+l2_first_term(term_type) - 1

       trig_l2_terms(iterm).term_number = iterm
       trig_l2_terms(iterm).term_name =   line
       trig_l2_terms(iterm).threshold = threshold
       trig_l2_terms(iterm).multiplicity = multiplicity
       trig_l2_terms(iterm).eta_min = eta_min
       trig_l2_terms(iterm).eta_max = eta_max
       trig_l2_terms(iterm).phi_min = phi_min
       trig_l2_terms(iterm).phi_max = phi_max

       trig_l2_bits(bitnumber).trig_andor(nterms_bit) = iterm
       trig_l2_bits(bitnumber).trig_andor_polarity(nterms_bit)
     &     = polarity
       trig_l2_bits(bitnumber).trig_nterms = nterms_bit
      endif

  999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:37  garren
c add rcs log line
c
