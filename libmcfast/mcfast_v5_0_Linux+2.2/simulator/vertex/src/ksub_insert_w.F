      integer function ksub_insert_w(w1, cov, idtyp, pos_info,
     &                             fixed_mass, origin, use_mass, 
     &                             mass, class,ik)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Inserts a particle in the track_kine list.
C
C  w1        track parameters in W format (Px,Py,Pz,E,x,y,z)
C
C  cov     real array (read)
C            Covariance matrix of TRKW (assumed to be 7x7)
C
C  idtyp     Integer variable (read)
C            Particle type
C
C  pos_info      integer variable (read)
C            1  ==> position info can be used in fit
C            0 ==> position info cannot be used in fit
C            Position info is always stored.
C
C  fixed_mass  integer (read)
C            1  ==> mass is fixed (fixed during track updates)
C            0 ==> mass is floating
C
C  origin   integer variable (read)
C            ===> particle origin, see track_kine_struct.inc for definitions

C  use_mass integer variable (read)
C            1==> use value of mass
C            0==> do not use value of mass
C
C  mass     real variable (read) 
C           mass of particle 
C
C  class    Integer variable (read)
C            User defined ID number ()
C
C  ik        Integer variable (write)
C            trk_kine track number in which info was stored.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Created 10/6/94  A. Boehnlein from P. Avery's KN code 

      implicit none

#include "const.inc"
#include "track_kine.inc"
#include "wtrack_struct.inc"
CC CLEO specific 
C#include "ksub_wpart.inc"

C     Calling arguments
      record /wtrack_struct/w1
      DFLOAT  cov(7,7)
      integer ik, pos_info, fixed_mass, use_mass, class, idtyp
      integer origin
      DFLOAT mass

C     Local variables
      DFLOAT pmagsq
C use HEP particle list id to determine charge
      integer hepchg
      external hepchg 
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      trk_num = trk_num + 1
      ik = trk_num
      if(ik.le.0 .or. ik.gt.max_trk) goto 9999

      trk_kine(ik).pos = 0
      trk_kine(ik).pos_info   = pos_info
      trk_kine(ik).fixed_mass = fixed_mass
      trk_kine(ik).icov       = 1
      trk_kine(ik).status     = 1
      trk_kine(ik).class      = class
      trk_kine(ik).id         = idtyp
      trk_kine(ik).origin     = origin
      
      trk_kine(ik).w.px       = w1.px
      trk_kine(ik).w.py       = w1.py
      trk_kine(ik).w.pz       = w1.pz
      

      pmagsq = w1.px**2 + w1.py**2 + w1.pz**2

      if(pmagsq .le. w1.e**2) then
        trk_kine(ik).w.e  = w1.e
        trk_kine(ik).mass = sqrt(w1.e**2 - pmagsq)
      else
        trk_kine(ik).w.e  = sqrt(pmagsq)
        trk_kine(ik).mass = 0.
      endif
      if(use_mass.eq.1) trk_kine(ik).mass = mass

      trk_kine(ik).w.x   = w1.x
      trk_kine(ik).w.y   = w1.y
      trk_kine(ik).w.z   = w1.z
      trk_kine(ik).w.pt  = w1.pt
      trk_kine(ik).w.p   = w1.p
      trk_kine(ik).w.q   = hepchg(idtyp)

      call ucopy(trk_kine(ik).w, trk_kine(ik).w0,WTRACK_WORD )
      call ucopy(cov, trk_kine(ik).cov(1,1), 7*7*FLOAT_WORD)

C     Normal exit
      ksub_insert_w = 0
      return

c     error exit
9999  ksub_insert_w = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:08  garren
c add rcs log line
c
