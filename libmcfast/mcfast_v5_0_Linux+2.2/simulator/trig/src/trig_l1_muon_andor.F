      subroutine trig_l1_muon_andor(error)
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : sets l1 andor terms for muons
C-
C-   Inputs  : none
C-   Outputs : 
C-             error  -- error condition
C-   Controls:
C-
C-   Created  11-may-1994   Amber S. Boehnlein
C-
c--------------------------------------------------------------------
      implicit none
#include "trig_term_index.params"
#include "trig_l1_terms.params"
#include "trig_term_struct.inc"
#include "trig_l1_terms.inc"
#include "trig_l1_track.inc"
#include "trig_l1_muon.inc"

C     output variable
      integer error
c     local variables
      integer iterm
      integer itrack,iitrack
      integer ier(ntrig_l1_muon_max)
      integer ntrack_satisfy
      real eta(ntrig_l1_muon_max), phi(ntrig_l1_muon_max)
      real pt(ntrig_l1_muon_max)
      integer first_term, last_term
C----------------------------------------------------------------------

      error = 0 
      
c loop over the number of terms
      first_term = l1_first_term(muon)
      last_term  = l1_first_term(muon) + l1_nterm_used(muon) - 1

      do iterm = first_term, last_term
c    
        trig_l1_terms(iterm).nevt_tried =
     &           trig_l1_terms(iterm).nevt_tried + 1
        trig_l1_terms(iterm).term_set = 1       
        trig_l1_terms(iterm).term_fired = 0

        ntrack_satisfy = 0
c  loop over muons
        do iitrack = 1, ntrig_l1_muon
c
           itrack = trig_l1_muon(iitrack).track
           if (iterm.eq.first_term) then 
             call mom_to_eta(trig_l1_track(itrack).w, pt(iitrack),
     &        eta(iitrack),phi(iitrack),ier(iitrack))
              if(ier(iitrack).ne.0) error = error + 1
           endif
c
           if (ier(iitrack).eq.0) then
             if(pt(iitrack).ge.trig_l1_terms(iterm).threshold.and.
     &           eta(iitrack).ge.trig_l1_terms(iterm).eta_min.and.
     &           eta(iitrack).le.trig_l1_terms(iterm).eta_max.and.
     &           phi(iitrack).ge.trig_l1_terms(iterm).phi_min.and.
     &           phi(iitrack).le.trig_l1_terms(iterm).phi_max)                 
     &        ntrack_satisfy = ntrack_satisfy + 1      
           endif
c
         enddo

         if(ntrack_satisfy.ge.trig_l1_terms(iterm).multiplicity)
     &   then
              trig_l1_terms(iterm).term_fired  = 1  
              trig_l1_terms(iterm).nevt_passed =
     &          trig_l1_terms(iterm).nevt_passed + 1
         endif               

      enddo
 999  return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:42  garren
c add rcs log line
c
