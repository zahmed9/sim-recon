      subroutine get_ranseed_from_time(iseed)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Set the random seed based on time of day. This routine is currently
c  only good to the nearest second.
c
c *iseed      integer variable (write)
c             random seed returned to caller
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


c     calling arguments
      integer iseed

c     local variables
      real time
      integer itime(3), idate(3)
      integer hdate(2), htime(2)
      character cdate*8, ctime*8
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Get date and time in hollerith. convert to character string
c     hdate = dd/mm/yy
c     htime = hh.mm.ss
      call datimh(hdate, htime)
      call uhtoc(hdate, 4, cdate, 8)
      call uhtoc(htime, 4, ctime, 8)

c     convert to integer arrays
      read(ctime,5001) itime
5001  format(i2,1x,i2,1x,i2)
      read(cdate,5001) idate

c     Calculate random seed from # seconds from the start of the month.
c     We really want to get down to the hundredths of a second.
      iseed = 86400*idate(1) + 3600*itime(1) + 60*itime(2) + itime(3)

c     Get the execution time just to get times to .001 sec
      call timex(time)
      iseed = iseed + 1000*time

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
