      subroutine evgen_start

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C      generate herwig events and translate to stdhep format
C      optionally decay heavy quarks with QQ
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "herwig61.inc"
#include "stdlun.inc"
#include "qq_flag.inc"

      integer iquest,ierr
      external hwudat
      integer i,j,n,lok,ikeep,istr,nh1,igen
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C   call user initialization routine
      call hwg_user_init

c    Open output files
      call hwg_open(istr)

C---initialise other common blocks
      call hwigin
c--- user can reset parameters at this point,
c--- otherwise values set in HWIGIN will be used.

C   This has to be called because hwigin sets parameters
      call hwg_user_reset

C set random number seeds using time of day if they are 0
      if(nrn(1) .eq. 0) then
        call get_ranseed_from_time(nrn(1))
        nrn(2) = abs( 9999999 - nrn(1) )
      endif

      lrsud = 0
      lwsud = 0
      tlout = 15.

C---define b-hadron decay model
      if(lqq) bdecay = 'CLEO'

C---compute parameter-dependent constants
      call hwuinc
C---call HWUSTA to make any particle stable
      call hwusta('PI0     ')
      call hwusta('K_S0    ')
C---user's initial calculations
      call hwabeg
C---initialise elementary process
      call hweini
C---initialize QQ if appropriate
      if(lqq) call stdqquset
C---write begin run record
      call stdflhwxsec
      call stdxwrt(100,istr,lok)
C---loop over events
      n = 1
      igen = 0
      do while (n.le.maxev)
	if(igen.lt.1000)then
          if (mod(igen,100).eq.0) write(lnhout,9001) igen, n-1
	elseif(igen.lt.10000)then
          if (mod(igen,1000).eq.0) write(lnhout,9001) igen, n-1
	elseif(igen.lt.100000)then
          if (mod(igen,10000).eq.0) write(lnhout,9001) igen, n-1
	else
          if (mod(igen,100000).eq.0) write(lnhout,9001) igen, n-1
	endif
C---these are filled by qq but not by herwig.
        call vzero ( vhep,  8*nmxhep )
C---initialise event
        call hwuine
C---generate hard subprocess
        call hwepro
C---generate parton cascades
        call hwbgen
C---do heavy quark decays
        call hwdhob
C---do cluster hadronization
        call hwcfor
C---do cluster decay
        call hwcdec
C---do unstable particle decays
        call hwdhad
C---do heavy flavour decays
        igen = igen + 1
C... first check to see if we want to keep the event
        call hwghep(1)
        call usr_filter_preqq(ikeep)
        nh1 = nhep
        if(ikeep.eq.1)then
	  call hwdhvy
C---add soft underlying event if needed
	  call hwmevt
C---finalise event
	  call hwufne
C---translate to STDHEP common block
	  call hwghep(1)
C
C...do we want to keep this event?
	  call usr_filter_postqq(ikeep)
	  if(ikeep.eq.1)then
            call stdflhwxsec
            if(n.le.maxpr) call heplst(1)
C---user's event analysis
            call hwanal(nh1)
C...   Write the event to disk
            call stdxwrt(1,istr,lok)
            if(lok.ne.0) write(lnhout,1001) lok
            n = n +1
	  endif
        else
C---finalise event even if it is not kept
	  call hwufne
        endif
      enddo
C---terminate elementary process
      call hwefin
C---user's terminal calculations
      call hwaend
C---write end run record
      call stdflhwxsec
      call stdxwrt(200,istr,lok)
C...print histograms
      call houtpu(lnhout)
      call histdo
C...   Close up shop
      call stdxend(istr)
      close(unit=lnhout)
      stop
 1001 format(' Problem ',I3,' encountered while writing event')
 9001 format(1X,'Events Generated: ',I10,'  Kept: ',I10)
      end

      subroutine hwabeg
C     USER'S ROUTINE FOR INITIALIZATION
  999 end

      subroutine hwaend
C     USER'S ROUTINE FOR TERMINAL CALCULATIONS, HISTOGRAM OUTPUT, ETC
#include "file_names.inc"
      call usr_end_job
      call hrput(0,file_hbk,'N')
  999 end

      subroutine hwanal (nh1)
C     USER'S ROUTINE TO ANALYSE DATA FROM EVENT

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C... fill histograms
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "stdhep.inc"
#include "qq_flag.inc"

C...   local variables
      integer nquark,lquark(50),nh1,ndif
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call stdquarklst(5,nquark,50,lquark)
      call hf1(1,float(nquark)+0.5,1.0)                
      call hf1(2,float(nhep)+0.5,1.0)                
      if ( lqq ) then
         ndif = nhep - nh1
         call hf1(3,float(nh1)+0.5,1.0)                
         call hf1(4,float(ndif)+0.5,1.0)                
      endif
      call usr_end_event
      return
      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.17  2000/01/26 02:51:43  bphyslib
c use herwig61.inc
c
c Revision 1.16  2000/01/25  21:18:16  garren
c hwdhqk has been renamed hwdhob
c
c Revision 1.15  1998/07/09  22:05:18  garren
c character name of K0S changed
c
c Revision 1.14  1998/07/09  21:00:21  garren
c for lund v6_115, herwig v5_9a, and isajet v7_37
c
c Revision 1.13  1998/05/11  19:19:44  garren
c get mods from v3_3_0
c
c Revision 1.12  1998/05/06  23:10:46  kutschke
c vzero vhep/vheps.  Add heartbeat printout.
c
c
