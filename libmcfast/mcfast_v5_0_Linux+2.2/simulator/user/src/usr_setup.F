      subroutine usr_setup

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   User initialization after geometry file has been read in
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      write(6,5000)
5000  format('usr_setup: this is a dummy routine')
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:41  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:08:05  garren
c add hooks to initialize user trigger code
c
