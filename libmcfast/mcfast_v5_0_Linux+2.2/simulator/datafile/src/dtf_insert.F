      subroutine dtf_insert(local_dataset, type)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Insert a dataset into the list.
c
c  *local_dataset dataset structure (read)
c          name of dataset
c
c  type    integer variable (read)
c          1 for signal dataset, 2 for background dataset
c
c  2/22/96 LGarren  pass argument as local dataset
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "dataset.inc"
#include "input_files.inc"

c     Calling arguments
      integer type
      record /dataset/ local_dataset

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Signal dataset
      if(type .eq. 1) then
        if(dtf_numsig .ge. dtf_maxsig) goto 9999
        dtf_numsig = dtf_numsig + 1
        dtf_sig(dtf_numsig).file = local_dataset.file
        dtf_sig(dtf_numsig).events = local_dataset.events
        dtf_sig(dtf_numsig).anal = local_dataset.anal
        dtf_sig(dtf_numsig).events = local_dataset.events
        dtf_sig(dtf_numsig).sigma = local_dataset.sigma
        dtf_sig(dtf_numsig).active = local_dataset.active

c     Background dataset
      else
        if(dtf_numback .ge. dtf_maxback) goto 9999
        dtf_numback = dtf_numback + 1
        dtf_back(dtf_numback).file = local_dataset.file
        dtf_back(dtf_numback).events = local_dataset.events
        dtf_back(dtf_numback).anal = local_dataset.anal
        dtf_back(dtf_numback).events = local_dataset.events
        dtf_back(dtf_numback).sigma = local_dataset.sigma
        dtf_back(dtf_numback).active = local_dataset.active

      endif

c     normal exit
      return

c     Error exit
9999  return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:10  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:28  garren
c add rcs log line
c
