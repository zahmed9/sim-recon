      subroutine dtf_addfile(name, type, error)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add data set to the list of input data sets
c
c  name         character variable (read)
c               name of file to be added to input list
c
c  type         integer variable (read)
c               1 = signal dataset, 2 = background dataset
c
c *error        integer variable (write)
c               = 0 if all OK
c
c    note:  if the string has the form @file.ext, the string is treated
c           as a file name containing a list of dataset names, one per
c           line. the file is opened and the data sets within it are
c           added to the dataset list.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "dataset.inc"
#include "input_files.inc"

c     Externals
      character*80 cmd_string, cmd_strip
#ifndef Linux  /* ABSOFT compiler cannot handle external character functions */
      external     cmd_string, cmd_strip 
#endif
      integer  cmd_lenstr
      external cmd_lenstr


c     calling arguments
      character*(*) name
      integer type, error

c     local variables
      integer leng, lun, num_max
      character*(lendat) string, cfile
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call cmd_getlun(lun)

c     Ordinary dataset name ... add to list
      if(name(1:1) .ne. '@') then
        cfile = name
        if(type .eq. 1) then
          if(dtf_numsig .ge. dtf_maxsig) goto 9999
          dtf_numsig = dtf_numsig + 1
          dtf_sig(dtf_numsig).file = cfile
          dtf_sig(dtf_numsig).active = 1
        else if(type .eq. 2) then
          if(dtf_numback .ge. dtf_maxback) goto 9999
          dtf_numback = dtf_numback + 1
          dtf_back(dtf_numback).file = cfile
          dtf_back(dtf_numback).active = 1
        endif
 
c     @file.ext ... read this file to get list of datasets to add
      else
        leng = cmd_lenstr(name)
        open(unit=lun, file=name(2:), status='old', err=9997)
100     read(lun, '(a)', end=200, err=9998) string
        string = cmd_strip(string)
        if(string .eq. ' ') goto 100

        cfile = cmd_string(string, error)
        leng = max(cmd_lenstr(cfile), 1)
        if(type .eq. 1) then
          if(dtf_numsig .lt. dtf_maxsig) then
            dtf_numsig = dtf_numsig + 1
            dtf_sig(dtf_numsig).file = cfile(:leng)
            dtf_sig(dtf_numsig).active = 1
          else
            num_max = dtf_maxsig
            goto 9999
          endif

        else
          if(dtf_numback .lt. dtf_maxback) then
            dtf_numback = dtf_numback + 1
            dtf_back(dtf_numback).file = cfile(:leng)
            dtf_back(dtf_numback).active = 1
          else
            num_max = dtf_maxback
            goto 9999
          endif
        endif

        goto 100

200     close(unit=lun)
      endif

c     normal exit
      error = 0
      return

c     open error
9997  error = 1
      leng = max(2, cmd_lenstr(name))
      write(6,5101) name(2:leng)
5101  format(' dtf_addfile: Could not open list file: ',a)
      return

c     read error
9998  error = 2
      close(unit=lun)
      leng = max(2, cmd_lenstr(name))
      write(6,5102) name(2:leng)
5102  format(' dtf_addfile: Error reading list file: ',a)
      return

c     overflow error
9999  error = 3
      close(unit=lun)
      leng = max(1, cmd_lenstr(cfile))
      write(6,5103) cfile(1:leng)
5103  format(' dtf_addfile: Overflow adding input data file: ',a)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:09  eugenio
c Initial revision
c
c Revision 1.3  1998/11/24 19:43:51  procario
c Remove external on character functions on Linux only
c
c Revision 1.2  1997/04/04  20:29:26  garren
c add rcs log line
c
