      subroutine usr_mcfio_out
c 11/7/94 ASB user routine for calling output from  MCFIO package
c 3/22/95 ASB Added track offline writting
c 8/3/95  T. Wenaus  Added geometry output
c 8/23/95 T. Wenaus  Added dbin-defined data structure output
c 9/01/95 ASB Changed calls to use STDHEPM--multi version.
c 8/28/96 ASB Added calhit output
c 10/10/98 Paul Eugenio (CMU) removed all blocks but STDHEP
      implicit none
#include "mcfio.inc"
#include "mcp_mcfio.inc"
#include "stdhep.inc"
c #include "mcfdat_dst.inc"

#define MCFIO_GEOMETRY 880
#define MCFIO_DST 881
#define MCFIO_CALHIT 701

        integer geom_to_xdr, dst_to_xdr
        external geom_to_xdr, dst_to_xdr
        integer xdr_stdhep_multi
        external xdr_stdhep_multi
        integer xdr_mcfast_track_offline
        external xdr_mcfast_track_offline
        integer xdr_cal_hits
        external xdr_cal_hits

        logical first
        data first /.true./
        save first
        integer check_for_dst_output
        external check_for_dst_output

        if (.not. mcfio_out) return

        call mcfio_SetEventInfo(ostr_out, MCFIO_RUNNUMBER, 456)        


        if (mcfio_block(ostr_out, MCFIO_STDHEPM, xdr_stdhep_multi)
     &        .eq. -1) then 
             print *, ' Error writing STDHEP block '
             STOP
        end if

        if (mcfio_NextEvent(ostr_out) .eq. -1) then 
             print *,'  Error writing next event, Stop '
             stop
         end if
         return
         end            
