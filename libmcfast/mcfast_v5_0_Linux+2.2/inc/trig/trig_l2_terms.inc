C----------------------------------------------------------------------
C-
C-   Created  26-FEB-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
       integer l2_terms_max(nterm_type)
       integer l2_first_term(nterm_type)
       integer l2_nterm_used(nterm_type)
      common /trig_l2_term_network/ l2_terms_max,l2_first_term,
     & l2_nterm_used
       record /trig_term_struct/ trig_l2_terms
      common /trig_l2_terms/ trig_l2_terms(nandor_terms_max)
