      logical function vtx_allow_id(id)

* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
* The STDHEP number scheme is quite complex.  Here we try to choose only  
* the hadrons, leptons and photons, W and Z.  We throw away quarks, diquarks 
* and gen codes.
*
* This routine called from vtx_fill. 
*
*                                      M. Procario 15 June 1994
*                                      Carnegie Mellon University
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none
*
      logical allow_id
      integer  id
*
*  Local varaibles
*
      integer j, k
* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
      if (abs(id).lt.100) then
*
*       Only the leptons are allowed below 100 
*
        if (abs(id).gt.10.and.abs(id).lt.20) then
          allow_id = .true.              !It's a lepton
        else if (abs(id).gt.21.and.abs(id).le.24) then
          allow_id = .true.              !Photon, W or Z
        else
          allow_id = .false.
        endif
      else
*
*       Only diquarks are disallowed above one hundred. Diquarks have
*       0 for the tens digit.
*
        j = id/10                        !Trim off the one's digit
        k = j - (j/10)*10                !Isolate the new one's digit
        if (k.eq.0) then
          allow_id = .false.             !It's a duquark
        else
          allow_id = .true.
        endif
      endif

      vtx_allow_id = allow_id

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:08:00  garren
c add hooks to initialize user trigger code
c
