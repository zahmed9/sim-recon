#ifndef TRIG_TERM_STRUCT
#define TRIG_TERM_STRUCT

C----------------------------------------------------------------------
C-
C-   Created  15-FEB-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
       integer nandor_terms_max
       parameter (nandor_terms_max=256)
C  This structure defines the "andor terms" to be used to as components
c  for trigger decision.  Each term has a name, number, a bit to signify
c  whether or not the term was set (to distinguish 0 as not set
c  from 0 as set low.), the state (1 high, 0 low), and values for pt 
c  or displace vertex distance threshold, and eta and phi ranges.
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c              term_name    !to be parsed from input info
c              term_number
c              term_set     !was the term set?
c              term_fired   !the state of the term
c              multiplicity !number of objects requested
c              threshold    !pt or distance threshold
c              eta_min      ! defaults to all eta
c              eta_max
c              phi_min      ! defaults to all phi
c              phi_max
c              nevt_tried   !number of events tried  
c              nevt_passed  !number of events which set this term true
c
       structure/trig_term_struct/
         character*40     term_name
         integer          term_number
         integer          term_set
         integer          term_fired
         integer          multiplicity
         real             threshold 
         real             eta_min  
         real             eta_max
         real             phi_min 
         real             phi_max
         integer          nevt_tried 
         integer          nevt_passed   
       end structure
#endif
