      real function get_gauss(dummy)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Generates random numbers distributed like gaussian with mean = 0 and
c  sigma = 1. The technique is based on Numerical Recipes, p. 202, using
c  the two dimensional gaussian to generate the distribution exactly.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Externals
      external rann
      real     rann

c     Calling arguments
      integer dummy

c     Local variables
      integer iset
      real fac, gset, rsq, v1, v2
      save iset, gset

      data iset/0/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(iset .eq. 0) then
 100    v1 = 2.*rann(dummy) - 1.
        v2 = 2.*rann(dummy) - 1.
        rsq = v1**2 + v2**2
        if(rsq.ge.1. .or. rsq.eq.0.) goto 100
        fac = sqrt(-2.*log(rsq)/rsq)
        gset = v1*fac
        get_gauss = v2*fac
        iset = 1
      else
        get_gauss = gset
        iset = 0
      endif

      return
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:49  eugenio
cInitial revision
c
cRevision 1.7  1997/03/10 22:07:32  garren
cadd c$Log$
cadd cRevision 1.1  2000/06/19 19:59:49  eugenio
cadd cInitial revision
cadd c
c
