      subroutine dtf_list(lun)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c     Write summary of data sets to Fortran unit lun
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "dataset.inc"
#include "input_files.inc"

c     Calling arguments
      integer lun

c     Local variables
      integer i, leng
      character*3 chr

c     External declarations
      integer cmd_lenstr
      external cmd_lenstr
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(lun .eq. 0) goto 1000

c     Write input data set list
      if(dtf_numsig .eq. 0) then
        write(lun, 5001)
5001    format(/,' No signal data sets defined')
      else
        write(lun, 5002) dtf_numsig
5002    format(/,' Total of ', i3,' signal data sets defined')

c     Write signal datasets
        do i=1,dtf_numsig
          leng = cmd_lenstr(dtf_sig(i).file)
          chr = ' '
          if(i .eq. dtf_sig_current) chr = '==>'
          if(dtf_sig(i).anal .eq. 1) chr = '  *'
          write(lun, 5003) chr, i, dtf_sig(i).events,
     *                     dtf_sig(i).file(:leng)
5003      format(1x, a3, i4, ' Events = ',i7, 2x, a)
        enddo

c     Write background datasets
        do i=1,dtf_numback
          leng = cmd_lenstr(dtf_back(i).file)
          chr = ' '
          if(i .eq. dtf_back_current) chr = '==>'
          if(dtf_back(i).anal .eq. 1) chr = '  *'
          write(lun, 5003) chr, i, dtf_back(i).events,
     *                     dtf_back(i).file(:leng)
        enddo

      endif

1000  return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:10  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:28  garren
c add rcs log line
c
