      subroutine mcp_readevent(type, status)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Read an event from a StdHep file. Non-event records are read in and
c   processed until an event record is read in.
c
c  Input:
c  type       integer variable
c             1 ==> read from signal file (file 1)
c             2 ==> read from background file (file 2)
c
c  Output:
c  status     integer variable
c             0 ==> Event returned
c             1 ==> End of data
c             2 ==> Error reading data
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_summary.inc"
#include "mcp_luns.inc"
#include "mcfio.inc"
#include "mcp_mcfio.inc"
#include "mcp_ioparam.inc"
#include "stdlun.inc"
c #include "stdcom1.inc"
c #include "dataset.inc"

c     Externals
      integer  cmd_lenstr
      logical  dtf_open
      external cmd_lenstr, dtf_open

c     Argument list
      integer type, status

c     Local variables
      integer leng, key, error, nsig, nback,lok
c      record /dataset/ new
      integer xdr_stdhep,xdr_stdhep_multi,xdr_stdhep_cm1
      external xdr_stdhep,xdr_stdhep_multi,xdr_stdhep_cm1
      integer xdr_mcfast_track_offline
      external xdr_mcfast_track_offline      
      integer geom_to_xdr, dst_to_xdr, xdr_cal_hits
      external geom_to_xdr, dst_to_xdr, xdr_cal_hits
      integer inum, nblocks
      integer blkids(20)
#define MCFIO_GEOMETRY 880
#define MCFIO_DST 881
#define MCFIO_CALHIT 701
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Modified 11/14/94 ASB added filetype for MCFIO input
c  Modified 3/22/95 ASB added reading for MCFIO track input
c  Modified 27/7/95 PLM update to STDHEP 3_00
 100  continue
      if(mcp_filetype(type).eq.OLD_STDHEP) then    ! old stdhep format
        write(mcp_llpt,1001)
        close(unit=lnhrdm(type))
        mcp_openfile(type) = .FALSE.
        call dtf_setdone(type)
        status = 1
        goto 1000

      else if (mcp_filetype(type).eq.MCF_IO_STDHEP .or. 
     1         mcp_filetype(type).eq.MCF_IO_MCFAST) then
        status = mcfio_NextEvent(ostr_in(type))
        call mcfio_InfoStreamInt(ostr_in(type), MCFIO_NUMEVTS, inum)
        call mcfio_InfoStreamInt(ostr_in(type), MCFIO_STATUS, inum)
        if (inum .eq. MCFIO_EOF) then
          call mcfio_Rewind(ostr_in(type))
          call mcfio_Close(ostr_in(type))
          mcp_openfile(type) = .FALSE.
          call dtf_setdone(type)
          status = 1
          goto 1000
        endif
        if (status .gt. 0) then
c find out how many blocks to read
          call mcfio_InfoEventInt(ostr_in(type),MCFIO_NUMBLOCKS,inum)
          if(inum.eq.0) status = - 1
          call mcfio_InfoEventInt(ostr_in(type),MCFIO_BLOCKIDS,blkids)
          do nblocks = 1, inum
            if( blkids(nblocks) .eq. MCFIO_STDHEP) then     
              status = mcfio_Block(ostr_in(type), MCFIO_STDHEP,
     &                 xdr_stdhep)
              call stdtcopy(2,ostr_in(type),lok)
            elseif( blkids(nblocks) .eq. MCFIO_STDHEPM) then     
c...zero stdhep common 
              call stdzero
              status = mcfio_Block(ostr_in(type), MCFIO_STDHEPM,
     &                 xdr_stdhep_multi)
            elseif (blkids(nblocks) .eq. MCFIO_OFFTRACKARRAYS) then
              status = mcfio_Block(ostr_in(type), MCFIO_OFFTRACKARRAYS,
     &                  xdr_mcfast_track_offline)
            elseif (blkids(nblocks) .eq. MCFIO_STDHEPBEG) then
              status = mcfio_block(ostr_in(type),MCFIO_STDHEPBEG,
     &              xdr_stdhep_cm1)
            elseif (blkids(nblocks) .eq. MCFIO_STDHEPEND) then
              status = mcfio_block(ostr_in(type),MCFIO_STDHEPEND,
     &              xdr_stdhep_cm1)
            elseif (blkids(nblocks) .eq. MCFIO_GEOMETRY) then
              status = mcfio_block(ostr_in(type),MCFIO_GEOMETRY,
     &              geom_to_xdr)
            elseif (blkids(nblocks) .eq. MCFIO_DST) then
              status = mcfio_block(ostr_in(type),MCFIO_DST,
     &              dst_to_xdr)
            elseif (blkids(nblocks) .eq. MCFIO_CALHIT) then
              status = mcfio_block(ostr_in(type),MCFIO_CALHIT,
     &              xdr_cal_hits)
            else
              print *, ' MCFAST: MCFIO input has undefined block!'
              status = -1
           endif
          enddo
        endif         
        if (status. le. 0) then
          call mcfio_Rewind(ostr_in(type))
          call mcfio_Close(ostr_in(type))
          mcp_openfile(type) = .FALSE.
          call dtf_setdone(type)
          status = 2
          goto 1000
        else
          status = 0
        endif
      endif
c     Exit
 1000 continue
      return
 1001 format('MCFAST: The old StdHep format is no longer supported')
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.6  1998/09/25 21:58:24  garren
c stdtcopy has a new argument
c
c Revision 1.5  1998/07/10  19:59:04  bphyslib
c fixes for StdHep v4_02
c
c Revision 1.4  1997/08/15  17:02:24  garren
c read back in event files generated by MCFast
c
c Revision 1.3  1997/04/04  18:07:56  garren
c add hooks to initialize user trigger code
c
