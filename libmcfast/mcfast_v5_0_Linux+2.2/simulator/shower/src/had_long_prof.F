
      subroutine had_long_prof(step,lambda,E,
     *                         alpha,beta,c,d,w,
     *                         edep)
c
c     Julia V. Yarba; 4-1-1996
c
      implicit none
c
c     Calling arguments
c 
c     Input :
c
      real step, lambda, E, alpha, beta, c, d, w
c
c     Output :
c
      real edep
c
c     Local arguments
c
      real dt, dlambda
c
c     Externals :
c
      external gamdis
      real gamdis

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (step .le. 0.) then
       step = 0.
       lambda = 0.
       edep = 0.
      end if

      dt = step * beta
 
      dlambda = lambda * d

      if (dt .gt. 0. .and. dlambda .gt. 0.) then
       edep = w*gamdis(dt,alpha) + (1.-w)*gamdis(dlambda,c)
       edep = abs(E*edep) 
      end if

      if (edep .lt. 0.) edep = 0.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.5  1997/04/04 20:30:11  garren
c add rcs log line
c
