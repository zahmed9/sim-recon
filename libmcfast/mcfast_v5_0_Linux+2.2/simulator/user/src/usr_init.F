      subroutine usr_init

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   User initialization
c   This is a good place to book your histograms and ntuples
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      write(6,5000)
5000  format('usr_init: this is a dummy routine')

c     >>>>>>>>>>>>>>>>>>>
c     call hcdir('//PAWC', ' ')
c     Book analysis histograms here




c     call hcdir('//PAWC', ' ')
c     call hcdir(hbk_topdir,' ')  !    to book large ntuples into file



c     >>>>>>>>>>>>>>>>>
c     Histoscope setup
c     leave this at the end of histogram and ntuple booking

      call hcdir('//PAWC', ' ')

c      call hs_hbook_setup('//PAWC')

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:41  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:08:04  garren
c add hooks to initialize user trigger code
c
