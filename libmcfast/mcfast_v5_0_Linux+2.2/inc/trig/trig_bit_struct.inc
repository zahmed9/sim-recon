#ifndef TRIG_BIT_STRUCT
#define TRIG_BIT_STRUCT

C----------------------------------------------------------------------
C-
C-   Created  15-FEB-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
C Structure to define trigger  -
C structure.  Each trigger condition is composed of set of "andor" terms
C which are required or vetoed.  See ANDOR_TERM_STRUCT.INC.  Each trigger
C consists of a name and bit number, array of andor terms and polarities
C to be used for the trigger (to be defined by the user), and the state
C of the trigger and accounting information filled by the simulation
C
C
C         trig_name       !Trigger name supplied by user
C         trig_bit        !Trigger bit associated with trigger name
C         trig_andor(nandor_terms_max)
C                                      !andor terms required for trigger
C         trig_andor_polarity(nandor_terms_max)
C                                      !polarity of andor terms (req or veto)
C         trig_nterms     !number of terms requested
C         trig_fired      !state of the trigger
C         nevt_tried      !number of events tried for this trigger
C         nevt_passed     !number of events passed for this trigger
C         use_trigger     !trigger should be used in the decision
C                                      !to pass or fail the event
C         ref_bit         !reference back to previous level trigger bit
C
       structure/trig_bit_struct/
         character*30 trig_name
         integer      trig_bit  
         integer      trig_andor(nandor_terms_max)
         integer      trig_andor_polarity(nandor_terms_max)
         integer      trig_nterms 
         integer      trig_fired 
         integer      nevt_tried
         integer      nevt_passed 
         logical      use_trigger
         integer      ref_bit  
       end structure
#endif
