      subroutine trig_sim_event(l1_passed,l2_passed)
c----------------------------------------------------------------------
c-
c-   purpose and methods : trigger simulation event processing loop
c-
c-   returned value  : none
c-   inputs  : none
c-   outputs : l1_passed, l2_passed -- did any triggers pass?
c-   controls: 
c-
c-   created  21-mar-1994   amber s. boehnlein
c-   first implementation does not include a second level
c-
c----------------------------------------------------------------------
      implicit none
      
c     returned variables
      logical l1_passed, l2_passed
c     local variable
      logical set
 
      logical trig_l2_needed
c--------------------------------------------------------------------------      
      l1_passed = .true.
      l2_passed = .true.
      call trig_l1_track()
      call trig_l1_muon()
      call trig_l1_calorimeter()
      call trig_l1_fangle()      
      call trig_l1_vertex()
      call trig_l1_user()
c 
      call trig_l1_bit_set()

      call trig_l1_passed(l1_passed, set)
c  
  999 return
      end      

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:51  garren
c add rcs log line
c
