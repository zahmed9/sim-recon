      subroutine usr_mcfio_out
c 11/7/94 ASB user routine for calling output from  MCFIO package
c 3/22/95 ASB Added track offline writting
c 8/3/95  T. Wenaus  Added geometry output
c 8/23/95 T. Wenaus  Added dbin-defined data structure output
c 9/01/95 ASB Changed calls to use STDHEPM--multi version.
c 8/28/96 ASB Added calhit output
      implicit none
#include "mcfio.inc"
#include "mcp_mcfio.inc"
#include "stdhep.inc"
c #include "mcfdat_dst.inc"   

c The template for MCFIO_DST is defined in simulator/dst/mcfdat.dst
c to update, change template and run gmkake to autogenrate output routines

#define MCFIO_GEOMETRY 880
#define MCFIO_DST 881
#define MCFIO_CALHIT 701

        integer geom_to_xdr, dst_to_xdr
        external geom_to_xdr, dst_to_xdr
        integer xdr_stdhep_multi
        external xdr_stdhep_multi
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

c $Id$
c $Log$
c Revision 1.3  2000/03/29 21:49:29  eugenio
c ugrade to mcfast v5.0
c
c Revision 1.8  1999/11/17 17:03:55  mcbride
c remove call to offline_track xdr filter
c
c Revision 1.7  1998/07/20  08:27:53  mcbride
c fix error message for calorimetry
c
c Revision 1.6  1997/04/04  18:08:04  garren
c add hooks to initialize user trigger code
c
