      subroutine pyt_user_init(istream)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   User initialization of the program. 
c   Open files for I/O. 
c   Call routine to read in Pythia variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "stdhep.inc"
#include "stdlun.inc"
#include "pydat1.inc"
#include "file_names.inc"
#include "pythia_user.inc"
#include "qq_flag.inc"

C... local variables
      integer i,istream
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C...   Initialize STDHEP unit numbers
      LNHOUT = 9
      LNHWRT = 0
      LNHRD = 0
      LNHDCY = 17

C...  Initialize jetset output unit
      MSTU(11) = LNHOUT

C... set default number of event to print to 1
      maxpr = 1

C     Set file names if blank
      if(file_input .eq. ' ')   file_input = 'pythia_exam.pyt'
      if(file_lpt .eq. ' ')     file_lpt = 'pythia_exam.lpt'
      if(file_evt_wrt .eq. ' ') file_evt_wrt = 'pythia_exam.evt'

      call pyt_command    !Get commands from input file

C...   Open the output file for histos, etc.
C      Write the name of the input file to it.
      open(LNHOUT,FILE=file_lpt,STATUS='NEW')
      write(LNHOUT,9000) file_input
9000  format(/'Input command file: ',a,/)

c     Set random seeds by time of day or use seed from file
      call pyt_get_seed

C... call pygive if necessary
      if(npygv.gt.0)then
        do i=1,npygv
          call pygive(pygvlst(i))
        enddo
      endif

C... set particle masses
c pyupda(1...) writes the jetset/pythia decay table
c     open(unit=lnhdcy,file='jetset.dcy',status='new')
c     call pyupda(1,lnhdcy)
c     close(unit=lnhdcy)
c pyupda(2...) reads the jetset/pythia decay table
      write(lnhout,9001) jetset_decay_file
9001  format(/'Reading jetset decay table: ',a,/)
      open(unit=lnhdcy,file=jetset_decay_file,status='old')
      call pyupda(2,lnhdcy)
      close(unit=lnhdcy)
      
C...   Book histograms.
      call bookhistos
C...
      CALL HOUTPU(LNHOUT)      

C...   Open the event output file 
      call stdxwinit(file_evt_wrt,'EVGEN with Pythia and QQ',
     1               maxev,istream,lok)

c...   Initialize Pythia
      call pyinit(frame, beam, target, cms_energy)

      RETURN
      END

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.6  1998/07/09 21:00:24  garren
c for lund v6_115, herwig v5_9a, and isajet v7_37
c
c Revision 1.5  1998/06/25  15:49:03  bphyslib
c add all necessary changes from v3_3
c
