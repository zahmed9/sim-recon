      real function rann(seq)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Returns a value distributed as a guassian with mean 0 and sigma 1.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Calling argument
      integer seq

c     Local variables
      real r
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(seq.le.0 .or. seq.gt.100) then
        call ranecu(r, 1, 1)
      else
        call ranecu(r, 1, seq)
      endif

      rann = r

      return
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:50  eugenio
cInitial revision
c
cRevision 1.2  1997/03/10 22:07:35  garren
cadd c$Log$
cadd cRevision 1.1  2000/06/19 19:59:50  eugenio
cadd cInitial revision
cadd c
c
