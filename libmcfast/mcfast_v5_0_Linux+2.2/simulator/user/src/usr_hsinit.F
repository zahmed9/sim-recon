      subroutine usr_hsinit

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Histoscope initialization 
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      write(6,5000)
5000  format('usr_hsinit: this is a dummy routine!!!,' 
     +        '  Histoscope NOT Called')

c      call hs_initialize('Mcfast_HistoScope')

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c     to use histoscope:
c   1)  Uncomment the call to Histoscope initialization above
c
c   2)  Add the following line at the end of histogram booking
c     
c      call hs_hbook_setup('//PAWC')
c
c   3)  Add the following once in each event loop to update histograms      
c
c      call hs_update
c
c   4)  Add the following line at the beginning of usr_hbsummary
c
c      call hs_complete
c
c   5) change the Makefile to include the histoscope libraries (before
c       packlib and include the necessary X libraries.
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:08:04  garren
c add hooks to initialize user trigger code
c
