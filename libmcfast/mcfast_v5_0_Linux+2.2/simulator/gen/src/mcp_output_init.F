      subroutine mcp_output_init()
c     opens for write a user specifed file 
c     restricted to writing the stdhep block for now
c     11/8/94  ASB
c      3/22/95 ASB, Added Track array
c      9/01/95 ASB, use STDHEPM 
c      9/11/95 TWenaus, add geometry and dbin-defined data structs
C      9/01/96  ASB, added calorimetery output 
      implicit none
      
#include "mcp_luns.inc"      
#include "mcfio.inc"
#include "mcp_mcfio.inc"
#include "mcp_params.inc"
       integer numblocks
       parameter (numblocks = 5)
       integer blkids(numblocks)
#define MCFIO_GEOMETRY 880
#define MCFIO_DST 881
#define MCFIO_CALHIT 701
       if(mcfio_out) then
         blkids(1) = MCFIO_STDHEPM
         blkids(2) = MCFIO_OFFTRACKARRAYS
         blkids(3) = MCFIO_GEOMETRY
         blkids(4) = MCFIO_DST
         blkids(5) = MCFIO_CALHIT
	 ostr_out = mcfio_OpenWriteDirect(mcf_file_out, 
     &   	   %val(0), %val(0), 
     &             mcp_maxevent, blkids, numblocks)
         if (ostr_out.eq. -1) then 
           write(6,6000)
           write(mcp_llpt,6000)
 6000      format ( ' Can t open MCFIO output file ')
         end if         
       endif
       return
       end 

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 18:07:54  garren
c add hooks to initialize user trigger code
c
