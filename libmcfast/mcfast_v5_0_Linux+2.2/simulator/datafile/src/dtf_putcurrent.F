      subroutine dtf_putcurrent(local_dataset, type)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Replaces the current dataset with one supplied by the caller. This
c  allows a user to replace or update the info in a dataset.
c
c *local_dataset dataset structure (read)
c          name of dataset to replace current one by
c
c  type    integer variable (read)
c          1 for signal dataset, 2 for background dataset
c
c  2/22/96 LGarren  pass argument as local dataset
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "dataset.inc"
#include "input_files.inc"

c     calling arguments
      record /dataset/ local_dataset
      integer type
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(type.eq.1 .and. dtf_sig_current.gt.0) then
        dtf_sig(dtf_sig_current).file = local_dataset.file
        dtf_sig(dtf_sig_current).events = local_dataset.events
        dtf_sig(dtf_sig_current).anal = local_dataset.anal
        dtf_sig(dtf_sig_current).sigma = local_dataset.sigma
        dtf_sig(dtf_sig_current).active = local_dataset.active
      else if(type.eq.2 .and. dtf_back_current.gt.0) then
        dtf_sig(dtf_sig_current).file = local_dataset.file
        dtf_sig(dtf_sig_current).events = local_dataset.events
        dtf_sig(dtf_sig_current).anal = local_dataset.anal
        dtf_sig(dtf_sig_current).sigma = local_dataset.sigma
        dtf_sig(dtf_sig_current).active = local_dataset.active
      endif

c     Normal exit
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:10  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:29  garren
c add rcs log line
c
