      subroutine ranseed_in_fill()
c
c     fills the two random number seeds from Mcfio output
c     created 5/29/96 A. Boehnlein
c
c***********************************************************
      implicit none
#include "mcp_ranseeds.inc"
#include "ranseeds.inc"
      mcp_ranseeds(1) = ranseeds(1).ranseed 
      mcp_ranseeds(2) = ranseeds(2).ranseed
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:01  garren
c add rcs log line
c
