      subroutine get_time(tsec)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Return the number of seconds since the start of 1994.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

      integer isl
      common /slate/ isl(40)         !Cernlib time info

c     Calling argument
      double precision tsec

c     Local variables
      integer id, it, i
      integer year, month, day, hour, minute, second
      integer month_day(12)
      double precision month_sec(12), month_cum(12), year_sec
      logical init
      data init/.TRUE./
      data month_day/31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31/

      save month_day, month_sec, month_cum, year_sec, init
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(init) then
        init = .FALSE.

c     Number of seconds in each month
c     Number of seconds in a year
c     Cumulative number of seconds to start of month
        year_sec = 0.
        month_cum(1) = 0
        do i=1,12
          month_sec(i) = month_day(i) * 86400.
          year_sec = year_sec + month_sec(i)
          if(i .gt. 1) month_cum(i) = month_cum(i-1) + month_sec(i-1)
        enddo
      endif

c     Arguments id, it are ignored
      call datime(id, it)

      year = isl(1)
      month = isl(2)
      day = isl(3)
      hour = isl(4)
      minute = isl(5)
      second = isl(6)

      tsec = (year-1994.)*year_sec + month_cum(month) + (day-1)*86400.
     *     + hour*3600. + minute*60. + second

      return
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:49  eugenio
cInitial revision
c
cRevision 1.2  1997/03/10 22:07:34  garren
cadd c$Log$
cadd cRevision 1.1  2000/06/19 19:59:49  eugenio
cadd cInitial revision
cadd c
c
