      subroutine dtf_getnext(new, type, error)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Get next dataset
c
c *new          dataset variable (write)
c               New dataset returned to caller
c
c  type         integer variable (read)
c               1 = signal dataset, 2 = background dataset
c
c *error        integer variable (write)
c               = 0 if all OK
c               = 1 if none left
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
      character*(lendat) cmd_string
#ifndef Linux  /* ABSOFT compiler cannot handle external character functions */
      external cmd_string
#endif
      integer  cmd_lenstr
      external cmd_lenstr

c     calling arguments
      record /dataset/ new
      integer type, error

c     local variables
      integer leng, lun, num_max
      character*(lendat) string, cfile
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Look for next active dataset
      if(type .eq. 1) then
100     if(dtf_sig_current .ge. dtf_numsig) goto 9998
        dtf_sig_current = dtf_sig_current + 1
        if(dtf_sig(dtf_sig_current).active .eq. 0) goto 100
        new.file = dtf_sig(dtf_sig_current).file
        new.anal = dtf_sig(dtf_sig_current).anal
        new.events = dtf_sig(dtf_sig_current).events
        new.sigma = dtf_sig(dtf_sig_current).sigma
        new.active = 1

      else if(type .eq. 2) then
200     if(dtf_back_current .ge. dtf_numback) goto 9998
        dtf_back_current = dtf_back_current + 1
        if(dtf_back(dtf_back_current).active .eq. 0) goto 200
        new.file = dtf_back(dtf_back_current).file
        new.anal = dtf_back(dtf_back_current).anal
        new.events = dtf_back(dtf_back_current).events
        new.sigma = dtf_back(dtf_back_current).sigma
        new.active = 1

      else
        goto 9999
      endif


c     Normal exit
      error = 0
      return

c     None left
9998  error = 1
      new.file = ' '
      new.anal = 0
      new.sigma = 0.
      new.events = 0
      new.active = 0
      return

c     Illegal value of type
9999  error = 2
      new.file = ' '
      new.anal = 0
      new.sigma = 0.
      new.events = 0
      new.active = 0
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:09  eugenio
c Initial revision
c
c Revision 1.3  1998/11/24 19:43:52  procario
c Remove external on character functions on Linux only
c
c Revision 1.2  1997/04/04  20:29:27  garren
c add rcs log line
c
