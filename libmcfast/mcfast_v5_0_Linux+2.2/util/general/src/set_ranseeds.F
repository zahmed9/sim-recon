      subroutine set_ranseeds(in_seeds, seq)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Initialize the RANECU random number generator
c
c  Input:
c  in_seeds(2)    integer array
c                 Input random seeds. If first one is 0, the time of day
c                 is used to compute the actual seed.
c
c  seq            integer variable
c                 Random sequence number. Must satisfy 1 <= seq <= 100
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Calling argument
      integer in_seeds(2), seq

c     Local variables
      integer seeds(2)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     If first seed is 0, set it based on time of month
      if(in_seeds(1) .eq. 0) then
        call get_ranseed_from_time(seeds(1))
      else
        seeds(1) = in_seeds(1)
      endif

c     Set second seed to the value specified by the user. If 0, set it
c     to 1.
      if(in_seeds(2) .eq. 0) then
        seeds(2) = 1
      else
        seeds(2) = in_seeds(2)
      endif

c     Set the seeds for the RANECU generator
      call ranecq(seeds(1), seeds(2), seq, 'S')

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
