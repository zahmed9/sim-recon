      integer function hepcmp(id)

C...Purpose: to compress the standard ID codes for use in mass and decay
C...arrays; also to check whether a given code actually is defined.

C      ID     = particle ID
C      hepcmp = compressed index

      integer id

      integer hepchg
      external hepchg

C...Subdivide standard ID code into constituent pieces.
      hepcmp=0
      kqa=iabs(id)
      kqn=mod(kqa/1000000000,10)
      kqna=mod(kqa/1000000,1000)
      kqnz=mod(kqa/1000,1000)
      kqx=mod(kqa/1000000,10)
      kqr=mod(kqa/100000,10)
      kql=mod(kqa/10000,10)
      kq3=mod(kqa/1000,10)
      kq2=mod(kqa/100,10)
      kq1=mod(kqa/10,10)
      kqj=mod(kqa,10)
      kqsm=(kqj-1)/2
      irt = mod(kqa,10000)
      k99=mod(kqa/100000,100)
      is = kqsm
      if(kqx.eq.9) is = kqsm + 5

C...Simple cases: direct translation or special codes.
      if(kqa.eq.0.or.kqa.ge.10000000) then
C... look for ions here
        if(kqn.eq.1 .and. kqna.gt.0 .and. id.gt.0) then
C... use stupid compression for now
          if(kqnz.eq.1 .and. kqna.le.3)then
            hepcmp = 1900 + 1*(kqnz-1) + kqna
            if(mod(kqj,2).ne.0) hepcmp = 0
          elseif(kqnz.eq.2 .and. (kqna.eq.3 .or. kqna.eq.4))then
            hepcmp = 1900 + 1*(kqnz-1) + kqna
            if(mod(kqj,2).eq.0) hepcmp = 0
          endif
        endif
C... illegal if not an ion
      elseif(kqa.le.100) then
        hepcmp=kqa
C... need to check antiparticle legality
        ich=hepchg(id)
        if(id.lt.0.and.ich.eq.0)then
          if(kqa.ge.1.and.kqa.le.8)then
C... quarks
          elseif(kqa.ge.11.and.kqa.le.18)then
C... leptons
          elseif(kqa.eq.41 .or. kqa.eq.42)then
C... R0 or LQ
          elseif(kqa.ge.81)then
C... internal definitions
          else
            hepcmp=0
          endif
        endif
      elseif(kqj.eq.0) then
C... KS and KL
        if(id.eq.130) hepcmp=102
        if(id.eq.310) hepcmp=101
C... reggeon, pomeron, odderon
        if(id.eq.110) hepcmp=107
        if(id.eq.990) hepcmp=108
        if(id.eq.9990) hepcmp=109
C...SUSY
      elseif(kqx.eq.1)then
        if(irt.lt.60 .and. kqr.eq.0) hepcmp = 110+irt
        ich=hepchg(id)
        if(id.lt.0.and.ich.eq.0)then
          if(irt.ge.1.and.irt.le.8)then
C... quarks
          elseif(irt.ge.11.and.irt.le.18)then
C... leptons
          else
            hepcmp=0
          endif
        endif
C...SUSY, excited
      elseif(kqx.eq.2 .or. kqx.eq.4)then
        if(irt.lt.20 .and. kqr.eq.0) hepcmp = 170 + (kqx-2)*20 + irt
C... technicolor
      elseif(kqx.eq.3)then
         if(id.eq.3000111) hepcmp = 191 
         if(kqa.eq.3000211) hepcmp = 192
         if(id.eq.3100111) hepcmp = 193 
         if(id.eq.3000113) hepcmp = 194
         if(kqa.eq.3000213) hepcmp = 195 
         if(id.eq.3000221) hepcmp = 196 
         if(id.eq.3000223) hepcmp = 197 
C... other exotics
      elseif(kqx.eq.5)then
         if(kqa.eq.5100061) hepcmp = 201
         if(kqa.eq.5100062) hepcmp = 202
         if(kqa.eq.5100024) hepcmp = 203
         if(kqa.eq.5100012) hepcmp = 204
         if(kqa.eq.5100014) hepcmp = 205
         if(kqa.eq.5100016) hepcmp = 206
C...miscellaneous particles
      elseif(k99.eq.99)then
        if(id.eq.9910113)  hepcmp = 231
        if(kqa.eq.9910211) hepcmp = 232
        if(id.eq.9910223)  hepcmp = 233
        if(id.eq.9910333)  hepcmp = 234
        if(id.eq.9910443)  hepcmp = 235
        if(kqa.eq.9912112) hepcmp = 236
        if(kqa.eq.9912212) hepcmp = 237
        if(id.eq.9920022)  hepcmp = 241
        if(kqa.eq.9922212) hepcmp = 242
C...undefined
      elseif(kqx.gt.4 .and. kqx.lt.9)then

C...Diquarks.
      elseif(kq1.eq.0) then
        if(kqx.ne.0 .and. kqr.ne.0 .and. kql.ne.0)then
C... no excited states
        elseif(kqj.ne.1.and.kqj.ne.3) then
C... only 2 spin states
        elseif(kq3.eq.0.or.kq3.eq.9.or.kq2.eq.0.or.kq2.eq.9) then
C... illegal (no gluons allowed)
        elseif(kq3.lt.kq2) then
C... illegal quark order
        elseif(kq3.eq.kq2 .and. kqj.eq.1) then
C... illegal spin
        else
C... all diquarks are the same...
          hepcmp=103
        endif

C...Mesons.
      elseif(kq3.eq.0) then
        if(kq2.eq.0.or.kq2.eq.9.or.kq1.eq.0.or.kq1.eq.9) then
C... illegal (no gluons allowed)
        elseif(kq2.lt.kq1) then
C... illegal quark order
        elseif(id.lt.0.and.(kq2.eq.kq1)) then
C... illegal antiparticle
        elseif(mod(kqj,2).eq.0)then
C... illegal spin
        elseif(kq2.le.2 .and. kq1.eq.1) then
	  hepcmp = 250 + (kq2-1)*120 + kqr*40 + kql*10 + is
	  if(kql.gt.3 .or. kqr.gt.2) hepcmp = 0
	elseif(kq2.eq.2 .and. kq1.eq.2) then
	  hepcmp = 490 + kqr*80 + kql*10 + is
	  if(kql.gt.7 .or. kqr.gt.2) hepcmp = 0
	elseif(kq2.eq.3 .and. kq1.eq.3) then
	  hepcmp = 730 + kqr*30 + kql*10 + is
	  if(kql.gt.2 .or. kqr.gt.1) hepcmp = 0
	elseif(kq2.eq.3 .and. kq1.le.2) then
	  hepcmp = 790 + (kq1-1)*120 + kqr*40 + kql*10 + is
	  if(kql.gt.3 .or. kqr.gt.2) hepcmp = 0
	elseif(kq2.eq.4 .and. kq1.le.3) then
	  hepcmp = 1030 + (kq1-1)*30 + kql*10 + is
	  if(kql.gt.2 .or. kqr.gt.0 .or. kqx.gt.0) hepcmp = 0
	elseif(kq2.eq.4 .and. kq1.eq.4) then
	  hepcmp = 1120 + kqr*40 + kql*10 + is
	  if(kql.gt.3 .or. kqr.gt.1) hepcmp = 0
	elseif(kq2.eq.5 .and. kq1.le.4) then
	  hepcmp = 1200 + (kq1-1)*30 + kql*10 + is
	  if(kql.gt.2 .or. kqr.gt.0 .or. kqx.gt.0) hepcmp = 0
	elseif(kq2.eq.5 .and. kq1.eq.5) then
	  hepcmp = 1320 + kqr*40 + kql*10 + is
	  if(kql.gt.3 .or. kqr.gt.3) hepcmp = 0
        elseif(kq2.eq.6)then
	  hepcmp = 1480 + (kq1-1)*10 + is
	  if(kql.gt.0 .or. kqr.gt.0 .or. kqx.gt.0) hepcmp = 0
        elseif(kq2.eq.7)then
	  hepcmp = 1540 + (kq1-1)*10 + is
	  if(kql.gt.0 .or. kqr.gt.0 .or. kqx.gt.0) hepcmp = 0
        elseif(kq2.eq.8)then
	  hepcmp = 1610 + (kq1-1)*10 + is
	  if(kql.gt.0 .or. kqr.gt.0 .or. kqx.gt.0) hepcmp = 0
        endif

C...Baryons.
      elseif(kqx.eq.0.and.(kqj.eq.2.or.kqj.eq.4)) then
C... no excited states and only spins 1/2 and 3/2
        if(kq3.eq.0.or.kq3.eq.9.or.kq2.eq.0.or.kq2.eq.9.or.
     1        kq1.eq.0.or.kq1.eq.9) then
C... illegal (no gluons allowed)
        elseif(kq3.lt.kq1.or.kq3.lt.kq2) then
C... illegal quark order
        elseif(kq3.ge.7) then
C... l and h baryons are all the same
          hepcmp=97+kq3
          if(kq3.eq.kq1.and.kq3.eq.kq2.and.kqj.eq.2) hepcmp=0
          if(kq2.lt.kq1 .and. kq3.eq.kq1) hepcmp=0
          if(kq2.lt.kq1 .and. kqj.eq.4) hepcmp=0
          if(kq3.gt.8) hepcmp=0
        elseif(kqj.eq.2) then
C...Spin 1/2 baryons.
          if(kq3.eq.kq1 .and. kq3.eq.kq2)then
          elseif(kq2.lt.kq1 .and. kq3.eq.kq1)then
          elseif(kq2.lt.kq1) then
C...antisymmtric (Lambda, etc.)
            hepcmp=1690+((kq3-1)*(kq3-2)*(kq3-3))/6+
     1                  ((kq1-1)*(kq1-2))/2+kq2
          else
C...symmtric
            hepcmp=1710+((kq3+1)*kq3*(kq3-1))/6+(kq2*(kq2-1))/2+kq1
          endif
        elseif(kqj.eq.4) then
C...Spin 3/2 baryons.
          if(kq2.lt.kq1 .and. kq3.eq.kq1)then
          elseif(kq2.lt.kq1) then
C...no excited states for antisymmetric baryons
          else
C...symmtric
            hepcmp=1770+((kq3+1)*kq3*(kq3-1))/6+(kq2*(kq2-1))/2+kq1
          endif
        endif

      endif

      return
      end
