      subroutine mcp_stable_fill

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Fill stable particle lists
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "stdhep.inc"
#include "gen_stable.inc"

c     Local variables
      integer mlist
      parameter(mlist=32)
      integer i, id, ihep, status, list(mlist), q(mlist)

c      ~Ome-   ~Xi0   ~Xi-  ~Sig+  ~Sig0   ~Lam  ~Sig-    ~p+     ~n
c         K-    pi-   tau+    mu+     e+
c         e-    mu-   tau-    gam    pi0     Kl    pi+     Ks     K+
c          n     p+   Sig-    Lam   Sig0   Sig+    Xi-    Xi0   Ome-

      data list/
     * -3334, -3322, -3312, -3222, -3212, -3122, -3112, -2212, -2112,
     *  -321,  -211,   -15,   -13,   -11,
     *    11,    13,    15,    22,   111,   130,   211,   310,   321,
     *  2112,  2212,  3112,  3122,  3212,  3222,  3312,  3322,  3334/

      data q/
     *    +1,     0,    +1,    -1,     0,     0,    +1,    -1,     0,
     *    -1,    -1,    +1,    +1,    +1,
     *    -1,    -1,    -1,     0,     0,     0,    +1,     0,    +1,
     *     0,    +1,    -1,     0,     0,    +1,    -1,     0,    -1/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Fill overall stable particle list (include intermediate or decay
c     in flight)
      stb_gen_num = 0
      do 500 ihep=1,nhep
        status =isthep(ihep)
        if( status .eq.              1 .or. 
     +      status .eq.              2 .or. 
     +      status .eq.            201 .or.
     +      status .eq. ISTHEP_SEC_INT .or.     
     +      status .eq.    ISTHEP_PAIR .or.
     +      status .eq.    ISTHEP_BREM      ) then
          id = idhep(ihep)
          do i=1,mlist
            if(abs(id) .eq. list(i)) goto 10
          enddo
          goto 500
10        if(stb_gen_num .lt. stb_gen_max) then
            stb_gen_num = stb_gen_num + 1
            stb_gen(stb_gen_num).q = sign(1,id) * q(i)
            stb_gen(stb_gen_num).status = status
            stb_gen(stb_gen_num).pdgtype = id
            stb_gen(stb_gen_num).hep = ihep
          endif
        endif
500   continue

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.3  1999/04/07 01:59:42  kutschke
c Keep particles which interacted with the detector.
c
c Revision 1.2  1997/04/04  18:07:57  garren
c add hooks to initialize user trigger code
c
