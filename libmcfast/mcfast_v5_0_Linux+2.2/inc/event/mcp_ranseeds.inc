*****************************************************************************
*  Random seeds at the start of the event in mcfast
*****************************************************************************

      integer ranseeds_max
      parameter(ranseeds_max = 2)
      integer ranseeds_num, ranseeds_dum
      
      integer mcp_ranseeds          !Random seeds at start of event
      
      common/mcp_ranseeds_c/
     *  ranseeds_num, ranseeds_dum, mcp_ranseeds(ranseeds_max)

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:37  eugenio
c Initial revision
c
c Revision 1.3  1999/11/18 04:15:23  mcbride
c fix variable names
c
c Revision 1.2  1999/11/17  16:55:48  mcbride
c updated common block name -- see devel. notes
c
