      subroutine muon_plots(w,keep)
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c    make plots...
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "stdhep.inc"
#include "wtrack_struct.inc"


c    Local variables
      integer hep,keep

      integer error

      DFLOAT eta,phi,theta

      record /wtrack_struct/ w


c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     for acceptance studies===> plot info for all tracks and accepted accepted
c                                    tracks

       call wtoeta(w,eta,phi,theta,error)
       if (error .ne. 0) return
           
       call hf1(10,real(w.p),1.) 
       call hf1(15,real(w.pt),1.) 
       call hf1(20,real(eta),1.)
       call hf1(30,real(phi),1.)

       if (keep .eq. 1) then
          call hf1(110,real(w.p),1.) 
          call hf1(115,real(w.pt),1.) 
          call hf1(120,real(eta),1.)
          call hf1(130,real(phi),1.) 
       endif
       return
       end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:05  garren
c add rcs log line
c
