
      subroutine em_long_prof(step,E,alpha,beta,edep)
c
c     Julia V. Yarba; 4-1-1996
c
      implicit none
c
c     Calling arguments
c 
c     Input :
c
      real step, E, alpha, beta
c
c     Output :
c
      real edep
c
c     Local arguments
c
      real dt
c
c     Externals :
c
      external gamdis
      real gamdis

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (step .le. 0.) then
       step = 0.
       edep = 0.
      end if

      dt = step * beta

      if (dt .gt. 0.) then
       edep = abs(E*gamdis(dt,alpha))
      end if

      if (edep .lt. 0.) edep = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:30:08  garren
c add rcs log line
c
