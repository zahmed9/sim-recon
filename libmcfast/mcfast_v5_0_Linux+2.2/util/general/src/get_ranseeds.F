      subroutine get_ranseeds(seeds, seq)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Return the random seeds for a given sequence.
c
c  Output:
c  seeds(2)       integer array
c                 Random seeds
c
c  Input:
c  seq            integer variable
c                 Random sequence number. Must satisfy 1 <= seq <= 100
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Calling argument
      integer seeds(2), seq
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call ranecq(seeds(1), seeds(2), seq, 'R')

      return
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:49  eugenio
cInitial revision
c
cRevision 1.2  1997/03/10 22:07:33  garren
cadd c$Log$
cadd cRevision 1.1  2000/06/19 19:59:49  eugenio
cadd cInitial revision
cadd c
c
