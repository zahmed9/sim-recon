      subroutine savehits
*
************************************************************************
*                                                                      *
* savehits: dispatches to hits registry functions for each detector    *
*           subsystem in the simulation.                               *
*                                                                      *
************************************************************************
*
* changes: Wed Jun 20 13:19:56 EDT 2007 B. Zihlmann 
*          add ipart to the function calls hitxxxxxxx() 
*

#include "geant321/gckine.inc"
#include "geant321/gcvolu.inc"
#include "geant321/gctmed.inc"
#include "geant321/gctrak.inc"
#include "geant321/gcphys.inc"

#define MAKE_HITS_WHEN_ILOSS_0    1

      character*4 cnames(15)
      equivalence (NAMES(1),cnames(1))

      integer nlevellast,nameslast,numberlast
      common /gcvolulast/nlevellast,nameslast(15),numberlast(15)
      save /gcvolulast/
      data nlevellast/0/

      logical hitopen
      save hitopen
      data hitopen/.false./

      real xin(4),xout(4),pin(5),pout(5),dEsum
      save xin,xout,pin,pout,dEsum

      integer isame
      integer level,nlevel_in

* Initialize a new hit when a particle enters a sensitive volume, unless
* it was here before and never left, in which case the existing hit should
* be allowed to continue to collect statistics without being disturbed.

      if (INWVOL.eq.1) then
        if (NLEVEL.eq.nlevellast) then
          do level=NLEVEL,1,-1
            if (NAMES(level).ne.nameslast(level).or.
     +          NUMBER(level).ne.numberlast(level)) then
              goto 3
            endif
          enddo
          return
        endif
    3   continue
        do level=1,NLEVEL
          nameslast(level) = NAMES(level)
          numberlast(level) = NUMBER(level)
        enddo
        nlevellast = NLEVEL
        xin(1) = VECT(1)
        xin(2) = VECT(2)
        xin(3) = VECT(3)
        xin(4) = TOFG
        pin(1) = VECT(4)
        pin(2) = VECT(5)
        pin(3) = VECT(6)
        pin(4) = GETOT
        pin(5) = VECT(7)
        dEsum = 0
        hitopen = .true.
        return
      elseif (INWVOL.eq.0) then
        dEsum = dEsum + DESTEP
        if (ISTOP.eq.0) then
          return
        endif
        xout(1) = VECT(1)
        xout(2) = VECT(2)
        xout(3) = VECT(3)
        xout(4) = TOFG
        pout(1) = VECT(4)
        pout(2) = VECT(5)
        pout(3) = VECT(6)
        pout(4) = GETOT
        pout(5) = VECT(7)
      elseif (ISVOL.eq.1) then
        dEsum = dEsum + DESTEP
        xout(1) = VECT(1)
        xout(2) = VECT(2)
        xout(3) = VECT(3)
        xout(4) = TOFG
        pout(1) = VECT(4)
        pout(2) = VECT(5)
        pout(3) = VECT(6)
        pout(4) = GETOT
        pout(5) = VECT(7)
      endif

* At this point, we know that the particle is leaving the current volume
* for some reason.  If no hit is being accumulated then ignore it, and
* clear the block on the last hit volume if not the current one.

      if (.not.hitopen) then
        if (NLEVEL.ne.nlevellast) then
          nlevellast = 0
        else
          do level=NLEVEL,1,-1
            if (NAMES(level).ne.nameslast(level).or.
     +          NUMBER(level).ne.numberlast(level)) then
              nlevellast = 0
              return
            endif
          enddo
        endif
        return
      endif

* A hit is being accumulated, but we may be about to enter a daughter
* volume inside the current one.  If so, we ignore the transition.

      if (INWVOL.eq.2.and.INGOTO.ne.0) then
        return
      endif

* Otherwise, we may be exiting a sensitive region or one of its contents;
* if a content then we have no way of knowing whether we are at the same
* time leaving the outer sensitive volume or merely passing through one
* of its interior interfaces.  At this point there is no way to find out
* except to do the rather expensive call to GINVOL for the current point.
* To do that we will need to save and restore the geometry state info.

      if (INWVOL.eq.2.and.NLEVEL.gt.nlevellast) then
        call GSCVOL
        NLEVEL = nlevellast
        call GINVOL(VECT,isame)
        call GFCVOL
        if (isame.ne.0) then
          return
        endif
      endif

* At this point we hide any inner volumes that should not interrupt the
* formation of a single hit by pretending that we are still in the mother;
* the true geometry information is restored before we exit.

      nlevel_in = NLEVEL
      NLEVEL = nlevellast

* At end of track segment in sensitive medium: register hit

      if ((cnames(NLEVEL).eq.'STRC').or.		! vertex cylinder
     +    (cnames(NLEVEL).eq.'STRP')) then		! vertex endcap
#ifdef MAKE_HITS_WHEN_ILOSS_0
        if ((ILOSS.eq.0).and.(CHARGE.ne.0)) then
          dEsum = 1e-3   ! 1 MeV in plastic
        endif
#endif
        if (dEsum.gt.0) then
          call hitStartCntr(xin,xout,pin,pout,dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
        endif
      elseif ((cnames(NLEVEL).eq.'STRA').or.		! CDC straight straw
     +        (cnames(NLEVEL).eq.'STLA').or.		! CDC stereo straw
     +        (cnames(NLEVEL).eq.'STLB')) then	! CDC close-packed stereo straw
#ifdef MAKE_HITS_WHEN_ILOSS_0
        if ((ILOSS.eq.0).and.(CHARGE.ne.0)) then
          dEsum = 1e-5   ! 10 KeV in gas
        endif
#endif
        if (dEsum.gt.0) then
          call hitCentralDC(xin,xout,pin,pout,dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
        endif
      elseif (cnames(NLEVEL)(1:3).eq.'FDA') then	! FDC anode drift cell
#ifdef MAKE_HITS_WHEN_ILOSS_0
        if ((ILOSS.eq.0).and.(CHARGE.ne.0)) then
          dEsum = 1e-5   ! 10 KeV in gas
        endif
#endif
        if (dEsum.gt.0) then
          call hitForwardDC(xin,xout,pin,pout,dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
        endif
      elseif (cnames(NLEVEL).eq.'CERW') then		! Cerenkov truth
        if (dEsum.gt.0) then
          call hitCerenkov(xin,xout,pin,pout,dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
        endif
      elseif (cnames(NLEVEL).eq.'CPMT') then		! Cerenkov counter
        if ((dEsum.gt.0).and.(IPART.eq.50)) then
          call hitCerenkov(xin,xout,pin,pout,-dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
        endif
      elseif ((cnames(NLEVEL).eq.'FTOC').or.		! forward TOF counter
     +        (cnames(NLEVEL).eq.'FTOH')) then
#ifdef MAKE_HITS_WHEN_ILOSS_0
        if ((ILOSS.eq.0).and.(CHARGE.ne.0)) then
          dEsum = 1e-2   ! 10 MeV in plastic
        endif
#endif
        if (dEsum.gt.0) then
          call hitForwardTOF(xin,xout,pin,pout,dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
        endif
      elseif (cnames(NLEVEL)(1:2).eq.'BM') then		! BCal segment
#ifdef MAKE_HITS_WHEN_ILOSS_0
        if ((ILOSS.eq.0).and.(CHARGE.ne.0)) then
          dEsum = 1e-2  ! 10 MeV in the calorimeter module
        endif
#endif
        if ((dEsum.gt.0).or.(ISTORY.ne.1)) then
          call hitBarrelEMcal(xin,xout,pin,pout,dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
          ISTORY = 1  ! this particle has entered the BCal (inherited trait)
        endif
      elseif (cnames(NLEVEL).eq.'GCAL') then		! GCal segment
#ifdef MAKE_HITS_WHEN_ILOSS_0
        if ((ILOSS.eq.0).and.(CHARGE.ne.0)) then
          dEsum = 1e-2  ! 10 MeV in the calorimeter module
        endif
#endif
        if ((dEsum.gt.0).or.(ISTORY.ne.1)) then
          call hitGapEMcal(xin,xout,pin,pout,dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
          ISTORY = 1  ! this particle has entered the GCal (inherited trait)
        endif
      elseif (cnames(NLEVEL).eq.'LGBL') then		! forward calorimeter
#ifdef MAKE_HITS_WHEN_ILOSS_0
        if ((ILOSS.eq.0).and.(CHARGE.ne.0)) then
          dEsum = 1e-2   ! 10 MeV in the calorimeter block
        endif
#endif
        if ((dEsum.ne.0).or.(ISTORY.ne.2)) then
          call hitForwardEMcal
     +                       (xin,xout,pin,pout,dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
          ISTORY = 2  ! this particle has entered the FCal (inherited trait)
        endif
      elseif (cnames(NLEVEL).eq.'LTBL') then		! Compton calorimeter
#ifdef MAKE_HITS_WHEN_ILOSS_0
        if ((ILOSS.eq.0).and.(CHARGE.ne.0)) then
          dEsum = 1e-2   ! 10 MeV in the calorimeter block
        endif
#endif
        if ((dEsum.ne.0).or.(ISTORY.ne.2)) then
          call hitComptonEMcal
     +                       (xin,xout,pin,pout,dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
          ISTORY = 2  ! this particle has entered the CCal (inherited trait)
        endif
      elseif ((cnames(NLEVEL).eq.'UPVP').or.		! UPV channel
     +        (cnames(NLEVEL).eq.'UPVC')) then
#ifdef MAKE_HITS_WHEN_ILOSS_0
        if ((ILOSS.eq.0).and.(CHARGE.ne.0)) then
          dEsum = 1e-2   ! 10 MeV in the calorimeter paddle
        endif
#endif
        if ((dEsum.ne.0).or.(ISTORY.ne.3)) then
          call hitUpstreamEMveto
     +                       (xin,xout,pin,pout,dEsum,ITRA,ISTAK,ISTORY,
     >          IPART)
          ISTORY = 3  ! this particle has entered the UPV (inherited trait)
        endif
      endif

* Mark this hit as closed, so that it does not get registered twice

      hitopen = .false.

* If this is the end of tracking for this particle, reset the saved state

      if (ISTOP.ne.0) then
        nlevellast = 0
      endif

* Restore the true geometry state and return

      NLEVEL = nlevel_in
      END