C----------------------------------------------------------------------
C-
C-   Created  26-FEB-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
       integer l1_terms_max(nterm_type)
       integer l1_first_term(nterm_type)
       integer l1_nterm_used(nterm_type)
      common /trig_l1_term_network/ l1_terms_max,l1_first_term,
     &  l1_nterm_used
       record /trig_term_struct/ trig_l1_terms
      common /trig_l1_terms/ trig_l1_terms(nandor_terms_max)
