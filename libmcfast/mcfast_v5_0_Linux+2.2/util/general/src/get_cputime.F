      subroutine get_cputime(tsec)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Return the number of cpu seconds since the start of the job.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Calling argument
      double precision tsec

c     Local variables
      real cptime
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Set execution times
      call timex(cptime)
      tsec = cptime

      return
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:49  eugenio
cInitial revision
c
cRevision 1.2  1997/03/10 22:07:32  garren
cadd c$Log$
cadd cRevision 1.1  2000/06/19 19:59:49  eugenio
cadd cInitial revision
cadd c
c
