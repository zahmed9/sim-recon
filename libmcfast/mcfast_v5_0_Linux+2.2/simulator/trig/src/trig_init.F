      subroutine trig_init
c----------------------------------------------------------------------
c-
c-   purpose and methods : initializes everything
c-
c-   inputs  :
c-   outputs : 
c-   controls: 
c-
c-   created  14-apr-1994   amber s. boehnlein
c-
c----------------------------------------------------------------------
      implicit none

c----------------------------------------------------------------------

      call trig_prog_reset
      call trig_scaler_reset
      call trig_term_network_init

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:39  garren
c add rcs log line
c
