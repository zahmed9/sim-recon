      subroutine get_ctime(cdate, ctime)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Return the date and time as ASCII strings
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Calling argument  - cdate needs at least 11 characters
      character*(*) cdate, ctime

c 
      integer isl
      common /slate/ isl(40)         !Cernlib time info

c     Local variables
      integer id, it
      character*2 hour, min, sec
      character*3 month(12)
      data month /'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug',
     1            'Sep','Oct','Nov','Dec'/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     call cern date and time routine
      call datime(id, it)

c     convert to character values
      if(isl(4).lt.10)then
          write(hour,103) isl(4)
      else
          write(hour,'(i2)') isl(4)
      endif
      if(isl(5).lt.10)then
          write(min,103) isl(5)
      else
          write(min,'(i2)') isl(5)
      endif
      if(isl(6).lt.10)then
          write(sec,103) isl(6)
      else
          write(sec,'(i2)') isl(6)
      endif

      write(cdate,101) isl(3), month(isl(2)), isl(1)
      write(ctime,102) hour, min, sec

      return
 101  format(i2,'-',a3,'-',i4)
 102  format(a2,':',a2,':',a2)
 103  format('0',i1)
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:49  eugenio
cInitial revision
c
cRevision 1.5  2000/01/04 17:38:40  garren
cdatime gets full year, so use it
c
c Revision 1.4  1999/10/07  17:49:12  garren
c use full year
c
c Revision 1.3  1997/03/10  22:07:32  garren
c add c$Log$
c add cRevision 1.1  2000/06/19 19:59:49  eugenio
c add cInitial revision
c add c
c add cRevision 1.5  2000/01/04 17:38:40  garren
c add cdatime gets full year, so use it
c add c
c Revision 1.4  1999/10/07  17:49:12  garren
c use full year
c
c
