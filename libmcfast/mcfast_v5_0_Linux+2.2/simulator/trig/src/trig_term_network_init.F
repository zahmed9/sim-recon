      subroutine trig_term_network_init
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : Initialize andor network
C-
C-   Inputs  : none
C-   Outputs : commons
C-   Controls:
C-
C-   Created  28-FEB-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
      implicit none
#include "trig_term_index.params"
#include "trig_l1_terms.params"
#include "trig_l2_terms.params"
#include "trig_term_struct.inc"
#include "trig_l1_terms.inc"
#include "trig_l2_terms.inc"
C----------------------------------------------------------------------
       l1_terms_max(track)    = l1_terms_track_max
       l1_first_term(track)   = 1
       l1_terms_max(muon)     = l1_terms_muon_max
       l1_first_term(muon)    = l1_first_term(track) +
     &                          l1_terms_max(track)
       l1_terms_max(calem)    = l1_terms_calem_max
       l1_first_term(calem)   = l1_first_term(muon) +
     &                          l1_terms_max(muon)
       l1_terms_max(caljt)    = l1_terms_caljt_max
       l1_first_term(caljt)   = l1_first_term(calem) +
     &                          l1_terms_max(calem)
       l1_terms_max(vertex)   = l1_terms_vertex_max
       l1_first_term(vertex)  = l1_first_term(caljt) +
     &                          l1_terms_max(caljt)
       l1_terms_max(calmet)   = l1_terms_calmet_max
       l1_first_term(calmet)  = l1_first_term(vertex) +
     &                          l1_terms_max(vertex)
       l1_terms_max(calscet)  = l1_terms_calscet_max
       l1_first_term(calscet) = l1_first_term(calmet) +
     &                          l1_terms_max(calmet)
       l1_terms_max(user)     = l1_terms_user_max
       l1_first_term(user)    = l1_first_term(calscet) +
     &                          l1_terms_max(calscet)
       l1_terms_max(fangl)    = l1_terms_fangl_max
       l1_first_term(fangl)   = l1_first_term(user) +
     &                          l1_terms_max(user)

C
C ****  repeat for level2
C
       l2_terms_max(track)    = l2_terms_track_max
       l2_first_term(track)   = 0
       l2_terms_max(muon)     = l2_terms_muon_max
       l2_first_term(muon)    = l2_first_term(track) +
     &                          l2_terms_max(track)
       l2_terms_max(calem)    = l2_terms_calem_max
       l2_first_term(calem)   = l2_first_term(muon) +
     &                          l2_terms_max(muon)
       l2_terms_max(caljt)    = l2_terms_caljt_max
       l2_first_term(caljt)   = l2_first_term(calem) +
     &                          l2_terms_max(calem)
       l2_terms_max(vertex)   = l2_terms_vertex_max
       l2_first_term(vertex)  = l2_first_term(caljt) +
     &                          l2_terms_max(caljt)
       l2_terms_max(calmet)   = l2_terms_calmet_max
       l2_first_term(calmet)  = l2_first_term(vertex) +
     &                          l2_terms_max(vertex)
       l2_terms_max(calscet)  = l2_terms_calscet_max
       l2_first_term(calscet) = l2_first_term(calmet) +
     &                          l2_terms_max(calmet)
       l2_terms_max(user)     = l2_terms_user_max
       l2_first_term(user)    = l2_first_term(calscet) +
     &                          l2_terms_max(calscet)
       l2_terms_max(fangl)    = l2_terms_fangl_max
       l2_first_term(fangl)   = l2_first_term(user) +
     &                          l2_terms_max(user)
  999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:52  garren
c add rcs log line
c
