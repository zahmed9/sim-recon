      subroutine evgen_start

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C...   Produce B'S with the PYTHIA generator and find the relative frequency
C      of production of various B mesons and baryons. In the inialization
C      routine UPYTHINIT, use PYGIVE to input non-default values
C      of some PYTHIA variables.
C
C      Convert events to the STDHEP HEPEVT format and write them to disk
C
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

C...  HEPEVT common block
#include "stdhep.inc"
#include "stdlun.inc"
#include "file_names.inc"
#include "pythia_user.inc"
#include "qq_flag.inc"

C...   The level of detail to output for end-of-run statistics.
      INTEGER MSTAT
      PARAMETER (MSTAT=1)

C...   local variables
      integer nquark,lquark(50)
      integer i,j,l,m,lok,ikeep,nh1,ndif,istr,igen
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C...   Initialize I/O and PYTHIA.
      CALL pyt_user_init(istr)

C...   Initialize QQ if appropriate
      if(lqq) call STDQQUSET

C...   Write begin run record
      CALL STDFLPYXSEC(maxev)
      CALL stdxwrt(100,istr,lok)

C...   Generate PYTHIA events. Make histos along the way.
      i = 1
      igen = 0
      do while (i.le.maxev)
	if(igen.lt.1000)then
          if (mod(igen,100).eq.0) write(lnhout,9001) igen, i-1
	elseif(igen.lt.10000)then
          if (mod(igen,1000).eq.0) write(lnhout,9001) igen, i-1
	elseif(igen.lt.100000)then
          if (mod(igen,10000).eq.0) write(lnhout,9001) igen, i-1
	else
          if (mod(igen,100000).eq.0) write(lnhout,9001) igen, i-1
	endif
        CALL PYEVNT
        igen = igen + 1
C...    Fill hepevt common
        CALL LUNHEP(1)
        NH1 = NHEP
C
C...do we want to keep this event?
        call usr_filter_preqq(IKEEP)
        IF(IKEEP.EQ.1)THEN

C... do QQ decay here
          if(lqq) call STDDECAYQQ

C... fill stdcm1 common for each event
          call stdflpyxsec(maxev)
C...do we want to keep this event?
          call usr_filter_postqq(IKEEP)
          IF(IKEEP.EQ.1)THEN

C...    Print the event if requested
            if(i.le.maxpr) CALL HEPLST(1)
C
C...
            CALL STDQUARKLST(5,NQUARK,50,LQUARK)
            CALL HF1(1,FLOAT(NQUARK)+0.5,1.0)                
            CALL HF1(2,FLOAT(NHEP)+0.5,1.0)                
            if(lqq)then
              NDIF = NHEP - NH1
              CALL HF1(3,FLOAT(NH1)+0.5,1.0)                
              CALL HF1(4,FLOAT(NDIF)+0.5,1.0)                
            endif

            call usr_end_event

C...   Write the event to disk
            CALL stdxwrt(1,istr,lok)
            IF(lok.NE.0) WRITE(LNHOUT,1001) lok
            i = i + 1
	  ENDIF
        ENDIF
C...   Continue generating events.
      enddo

C...   Write end run record
      call stdflpyxsec(maxev)
      call stdxwrt(200,istr,lok)

C...   Print end of run statistics.
      CALL PYSTAT(MSTAT)

C... call user's end-of-job routine
      call usr_end_job

C...   Send HBOOK ouput to the user unit.
      CALL HIDOPT(0,'BLAC')
      CALL HPRINT(0)
C...
      CALL HRPUT(0,file_hbk,'N')
c...   Save random number seed
      call pyt_save_seed
      
C...   Close up shop
      call stdxend(istr)
      CLOSE(LNHOUT)

1001  format(' problem ',I3,' encountered while writing event')
 9001 format(1X,'Events Generated: ',I10,'  Kept: ',I10)
      stop
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.9  1998/06/25 15:49:03  bphyslib
c add all necessary changes from v3_3
c 
