      subroutine trig_l1_trk_andor(error)
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : sets l1 andor terms for tracking
C-
C-   Inputs  : none
C-   Outputs : 
C-             error  -- error condition
C-   Controls:
C-
C-   Created  21-mar-1994   Amber S. Boehnlein
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
      integer itrack
      integer ier(ntrig_l1_track_max)
      integer ntrack_satisfy
      real eta(ntrig_l1_track_max), phi(ntrig_l1_track_max)
      real pt(ntrig_l1_track_max)
      integer first_term, last_term
C----------------------------------------------------------------------

      error = 0 
      
c loop over the number of terms
      first_term = l1_first_term(track)
      last_term  = l1_first_term(track) + l1_nterm_used(track) - 1

      do iterm = first_term, last_term
c    
        trig_l1_terms(iterm).nevt_tried =
     &           trig_l1_terms(iterm).nevt_tried + 1
        trig_l1_terms(iterm).term_set = 1       
        trig_l1_terms(iterm).term_fired = 0

        ntrack_satisfy = 0
c  loop over tracks
        do itrack = 1, ntrig_l1_track
c
           if (iterm.eq.first_term) then 
             call mom_to_eta(trig_l1_track(itrack).w,pt(itrack),
     &        eta(itrack),phi(itrack),ier(itrack))
              if(ier(itrack).ne.0) error = error + 1
           endif
c
           if (ier(itrack).eq.0) then
             if(pt(itrack).ge.trig_l1_terms(iterm).threshold.and.
     &           eta(itrack).ge.trig_l1_terms(iterm).eta_min.and.
     &           eta(itrack).le.trig_l1_terms(iterm).eta_max.and.
     &           phi(itrack).ge.trig_l1_terms(iterm).phi_min.and.
     &           phi(itrack).le.trig_l1_terms(iterm).phi_max)                 
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
999   return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:45  garren
c add rcs log line
c
