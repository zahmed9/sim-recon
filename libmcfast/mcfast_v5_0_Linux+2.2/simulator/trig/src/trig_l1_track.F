      subroutine trig_l1_track()
c----------------------------------------------------------------------
c-
c-   purpose and methods : calling routine for level 1 
c-                         tracking trigger
c-                         
c-   returned value  : none
c-   inputs  : 
c-   outputs : 
c-   controls: 
c-
c-   created  21-mar-1994   amber s. boehnlein
c-
c----------------------------------------------------------------------
      implicit none
c     local variables
  
      integer ier
      
      ier = 0

C

      if (ier.ne.0) then
        write(6,*) 'TRIG l1 error filling tracking banks'
        goto 999
      endif

      call trig_l1_track_fill
c     tracking banks are filled -- set andor terms
      call trig_l1_trk_andor(ier)

      if (ier.ne.0) then
        write(6,*) 'TRIG l1 error setting tracking terms'
        goto 999
      endif

  999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:43  garren
c add rcs log line
c
