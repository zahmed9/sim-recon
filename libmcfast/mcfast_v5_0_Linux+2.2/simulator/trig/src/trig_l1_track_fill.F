      subroutine trig_l1_track_fill
c----------------------------------------------------------------------
c-
c-   purpose and methods : fill online tracking bank
c-                         3/22/94 -- just copy recon bank
c-                                    
c-                         
c-   returned value  : none
c-   inputs  : 
c-   outputs : 
c-   controls: 
c-
c-   created  21-mar-1994   amber s. boehnlein
c-   modified 11-may-1994   ASB, added filling for muons, hopefully
c-                          temporary
c-
c----------------------------------------------------------------------
      implicit none

#include "stdhep.inc"
#include "trig_l1_track.inc"
#include "trig_l1_muon.inc"
#include "const.inc"

c     Externals
      real     stdchg
      external stdchg

c     local variables  
      integer ier
      integer icov, jcov, it, id
      DFLOAT convert
c-----------------------------------------------------------------------      

      ier = 0
      ntrig_l1_track = 0
      ntrig_l1_muon  = 0
      do it=1,nhep

c     Require particle be final state or intermediate particle. This
c     gets rid of isthep = 3 particles which are p, pbar in some generators.
        if(isthep(it).ne.1 .and. isthep(it).ne.2) goto 500

c     Only allow e, mu, pi, K, p
        id = abs(idhep(it))
        if(id.ne.11 .and. id.ne.13 .and. id.ne.211 .and. id.ne.321 .and.
     *     id.ne.2212) goto 500
     
        if (ntrig_l1_track .ge. ntrig_l1_track_max) goto 9999
        ntrig_l1_track = ntrig_l1_track + 1
        convert = 1.e-3 * unit_meter
        trig_l1_track(ntrig_l1_track).w.px   = phep(1,it)
        trig_l1_track(ntrig_l1_track).w.py   = phep(2,it)
        trig_l1_track(ntrig_l1_track).w.pz   = phep(3,it)
        trig_l1_track(ntrig_l1_track).w.E    = phep(4,it)
        trig_l1_track(ntrig_l1_track).w.x    = vhep(1,it) * convert
        trig_l1_track(ntrig_l1_track).w.y    = vhep(2,it) * convert
        trig_l1_track(ntrig_l1_track).w.z    = vhep(3,it) * convert
        trig_l1_track(ntrig_l1_track).w.pt   = sqrt(phep(1,it)**2 + 
     &                                            phep(2,it)**2)
        trig_l1_track(ntrig_l1_track).w.p    = sqrt(phep(1,it)**2 
     &                                       +    phep(2,it)**2 + 
     *                                            phep(3,it)**2)
        trig_l1_track(ntrig_l1_track).w.q    = stdchg(idhep(it))
        trig_l1_track(ntrig_l1_track).mass = phep(5,it)
        do icov = 1, 7
          do jcov = 1, 7
            trig_l1_track(ntrig_l1_track).cov(icov,jcov) = 0.
          enddo
        enddo    
        trig_l1_track(ntrig_l1_track).hep         = it
        trig_l1_track(ntrig_l1_track).icov        = 0
        trig_l1_track(ntrig_l1_track).nhit        = 0
        trig_l1_track(ntrig_l1_track).nhit_sil    = 0
        trig_l1_track(ntrig_l1_track).nhit_stereo = 0


        if(id.eq.13) then
           if (ntrig_l1_muon .ge. ntrig_l1_muon_max) goto 9998
           ntrig_l1_muon = ntrig_l1_muon + 1
           trig_l1_muon(ntrig_l1_muon).track = ntrig_l1_track
           trig_l1_muon(ntrig_l1_muon).prob  = 1.0
        endif
c     Come here if wrong kind of particle
 500    continue
      enddo      
c
 999  return       ! normal return
c
 9998 write(6,1000) ntrig_l1_muon_max
 1000 format('trig_l1_track_fill: # of muons exceeds maximum', i5)
      return     
c
 9999 write(6,1001) ntrig_l1_track_max
 1001 format('trig_l1_track_fill: # of tracks exceeds maximum', i5)
      return     
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.5  1997/04/04 20:30:44  garren
c add rcs log line
c
