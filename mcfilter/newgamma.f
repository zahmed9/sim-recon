*
      subroutine newgamma(p)
c
c     takes a photon 4-vector (stored in p)
c     and smears it accoding to the resolution function:
*
*        Modified: 14 May 1998 -- P(px,py,pz,E)
c
c     sigma     stat
c     ----- =  ------   + floor
c       E      sqrt(E)
c
CCCC      include 'dev.inc'
      real p(4)
*
      stat  = 0.05
      floor = 0.02
*
      sigma=p(4)*floor + sqrt(p(4))*stat
cvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
      sigma=0.
c^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 1    continue
      eold=p(4)
      enew=p(4)+sigma*gausran(dummy)
      if(enew.le.0.) go to 1
      do i=1,4
         p(i)=p(i)*enew/eold
      enddo
      return
      end
