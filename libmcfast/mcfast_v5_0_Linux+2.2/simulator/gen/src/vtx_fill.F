      subroutine vtx_fill

*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*  In STDHEP the vertices are stored multiple times with each track from
*  each vertex. This routine searches through STDHEP and builds a list
*  of vertices. The stored information is descibed in vtxhep.inc.
*
*  Two arrays of pointers to these vertices indexed by track are filled.
*     ipvhep(it) = production vertex of track it
*     idvhep(it) = decay vertex of track it (0 if stable)
*
*                                        M. Procario 17 May 1994 
*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none
*
#include "const.inc"
#include "stdhep.inc"
#include "vtxhep.inc"
*
      logical  vtx_allow_id
      external vtx_allow_id
*
*     Local variables
*
      integer  idone(NMXHEP), itr, ivtx, idau, ndau 
      integer   list_daut(NMXHEP), len_list, imoth
      DFLOAT conv
*
*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
*     Convert mm to our units
      conv = 0.001 * unit_meter

      call vzero(idone,NHEP)
      call vzero(ipvhep,NHEP)
      call vzero(idvhep,NHEP)
*
      ivtx = 0
*
*     Loop over all tracks store the production vertexes 
*
      do itr=1,nhep
*
*       If the mother does not have any daughters, set mother to 0.
*       This happens for particles whose mother is a primary beam
*       particle. The second if statement must be at a different level
*       because Fortran evaluates both expressions even if the first
*       is false.
*
        imoth = jmohep(1,itr)
        if(imoth .gt. 0) then
          if(jdahep(1,imoth) .eq. 0) imoth = 0
        endif

        if (idone(itr).eq.0) then
*
*          Haven't looked at this track yet 
*
          if (isthep(itr).le.2) then
*
*           The only thing below 100 that we want are the leptons. 
*           They lie between 10 and 20.
*
            if ( vtx_allow_id(idhep(itr)) ) then 

c     Convert to our units and store
              ivtx = ivtx + 1
              vtx_pos(1,ivtx) = vhep(1,itr)*conv
              vtx_pos(2,ivtx) = vhep(2,itr)*conv
              vtx_pos(3,ivtx) = vhep(3,itr)*conv
              vtx_pos(4,ivtx) = vhep(4,itr)*conv
*     
              if(imoth .gt. 0) then
                if ( vtx_allow_id(idhep(imoth)) ) then 
                  vtx_intrk(ivtx) = jmohep(1,itr)     !Store incoming track
                else
                  vtx_intrk(ivtx) = 0
                endif
*
*         Go back up to the mother to find other daughters
*
                len_list = NMXHEP
                call stddautrlst(imoth, ndau, len_list, list_daut)
                do idau = 1, ndau 
                  ipvhep(list_daut(idau)) = ivtx
                  idone(list_daut(idau)) = 1
                enddo
                vtx_outrk(ivtx) = list_daut(1)  !Store first outgoing 
                vtx_ntrk(ivtx)  = ndau          !Num of outgoing
*
*         If no mother, set incoming track to 0. Set vertex parameters
*         since they are set nowhere else.
*
              else
                vtx_intrk(ivtx) = 0
                if(vtx_outrk(ivtx) .eq. 0) vtx_outrk(ivtx) = itr
                vtx_ntrk(ivtx) = vtx_ntrk(ivtx) + 1
                ipvhep(itr) = ivtx
                idone(itr) = 1
              endif
            endif
          endif
        endif
      enddo
*
*     Store the number of vertices found
*
      vtx_hep_n = ivtx
*
*     All vertices have been stored now associate the decay vertices.
*      
      do itr = 1, nhep
        if (idone(itr).eq.1) then
          idau = jdahep(1,itr)        !Get a daughter
          if (idau.ne.0) then
            idvhep(itr) = ipvhep(idau)  !Production vertex of daughter is
                                        !the decay vertex of the mother
          endif
        else
          
        endif
      enddo
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:08:01  garren
c add hooks to initialize user trigger code
c
          
