      integer function pdgtran(ID,mconv)
C...convert (mconv=1) from PDG98 numbering scheme to STD numbering scheme
C...     or (mconv=2) from STD numbering scheme to PDG98 numbering scheme
C
C           ID = particle identification number

#include "stdlun.inc"
C... ITABJ(I) converts miscellaneous PDG92 particle ID's to a standard scheme
      integer itabj(100,2), noant(8,2)

      data itabj/1,2,3,4,5,6,7,8,0,0,
     1           11,12,13,14,15,16,17,18,0,0,
     2           21,22,23,24,25,0,0,0,0,0,
     3           0,32,33,34,35,36,37,0,39,0,
     4           41,42,0,0,0,0,0,0,0,0,
     5           0,0,0,0,0,0,0,0,0,0,
     6           0,0,0,0,0,0,0,0,0,0,
     7           0,0,0,0,0,0,0,0,0,0,
     8           81,82,83,84,85,86,87,88,89,90,
     9           91,92,93,94,95,96,97,98,99,100,
     *           1,2,3,4,5,6,7,8,0,0,
     1           11,12,13,14,15,16,17,18,0,0,
     2           21,22,23,24,25,0,0,0,0,0,
     3           0,32,33,34,35,36,37,0,39,0,
     4           41,42,0,0,0,0,0,0,0,0,
     5           0,0,0,0,0,0,0,0,0,0,
     6           0,0,0,0,0,0,0,0,0,0,
     7           0,0,0,0,0,0,0,0,0,0,
     8           81,82,83,84,85,86,87,88,89,90,
     9           91,92,93,94,95,96,97,98,99,100/
      data noant/-21,-22,-23,-25,-32,-33,-35,-36,
     1           -21,-22,-23,-25,-32,-33,-35,-36/
      save itabj,noant

      pdgtran=id
      ida=iabs(id)
      j1=mod(ida,10)
      i1=mod(ida/10,10)
      i2=mod(ida/100,10)
      i3=mod(ida/1000,10)
      i4=mod(ida/10000,10)
      ksusy = mod(ida/1000000,10)
      ku = mod(ida/10000000,10)
      kqn=mod(ida/1000000000,10)

      if(ida.eq.0)then
C..        write(lnhout,*) ' PDGTRAN 1: particle ID is zero'
      elseif(mconv.lt.1 .or. mconv.gt.2)then
        pdgtran=0
        write(lnhout,*) ' PDGTRAN 2: unallowed conversion option'
C... ions not allowed
      elseif(kqn.eq.1) then
        pdgtran=0
        write(lnhout,*) ' PDGTRAN 3: unallowed ion'
      elseif(ksusy.eq.1 .or. ksusy.eq.2) then
C...SUSY 
      elseif(ksusy.eq.3) then
C...technicolor
        if(mconv.eq.2) then
	   if(ida.eq.3100111)  pdgtran=0
	endif
      elseif(ksusy.eq.4) then
C...excited quarks and leptons
      elseif(ida.le.100)then
C...Higgs, etc.
        pdgtran=isign(itabj(ida,mconv),id)
C...check for illegal antiparticles
        if(id.lt.0)then
          do 101 j=1,8
            if(pdgtran.eq.noant(j,mconv)) pdgtran = 0
 101      continue
        endif
      elseif(j1.eq.0)then
C...special particles
C...check for illegal anti KS, KL
          if(id.eq.-130 .or. id.eq.-310) pdgtran=0
      elseif(ksusy.eq.9 .and. ku.eq.9 .and. mconv.eq.2) then
          pdgtran = 0
      elseif(i1.ne.0 .and. i3.ne.0 .and. j1.eq.2)then
C...spin 1/2 baryons
C...no excited baryon states
        if(mconv.eq.1)then
          if(i4.ne.0) pdgtran = 0
          if(i3.eq.1) pdgtran = 0
          if(i3.eq.2 .and. i2.eq.1 .and. i1.eq.2) pdgtran = 0
          if(i3.eq.2 .and. i2.eq.2 .and. i1.eq.2) pdgtran = 0
        elseif(mconv.eq.2) then
	  if(i3.ge.6) pdgtran=0
        endif
      elseif(i1.ne.0 .and. i3.ne.0 .and. j1.eq.4)then
C...spin 3/2 baryons
C...no excited baryon states
        if(mconv.eq.1)then
          if(i4.ne.0) pdgtran = 0
          if(i3.ge.3 .and. i2.eq.1 .and. i1.eq.2) pdgtran = 0
          if(i3.eq.1 .and. i2.eq.2 .and. i1.eq.1) pdgtran = 0
          if(i3.eq.2 .and. i2.eq.1 .and. i1.eq.2) pdgtran = 0
        elseif(mconv.eq.2) then
	  if(i3.ge.6) pdgtran=0
        endif
      elseif(i1.ne.0 .and. i2.ne.0 .and. i3.eq.0)then
C...mesons 
        if(mconv.eq.1)then
        elseif(mconv.eq.2) then
          if(ida.eq.9020553) pdgtran=0
	  if(i2.ge.6) pdgtran=0
        endif
C...check for illegal antiparticles
        if(i1.eq.i2 .and. id.lt.0) pdgtran=0
      elseif(i2.ne.0 .and. i3.ne.0 .and. i1.eq.0)then
C...diquarks
	if(i3.ge.6) pdgtran=0
      else
C...undefined
        pdgtran=0
      endif
C...check for illegal anti KS, KL
      if(id.eq.-130 .or. id.eq.-310) pdgtran=0
#if HEPDBG
C...there are too many warnings - use only for debugging purposes
      if(pdgtran.eq.0 .and. ida.ne.0)then
        if(mconv.eq.1) write(lnhout,111) id
        if(mconv.eq.2) write(lnhout,112) id
      endif
#endif
      return
 111  format('  PDGTRAN 3: PDG98 particle ',I8,' translates to zero')
 112  format('  PDGTRAN 3: STD   particle ',I8,' translates to zero')
      end
