       subroutine muon_init
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    initialization for muon offline routines
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none
 
#include "mcp_debug.inc"      
#include "mcp_hbook.inc"
#include "mcp_files.inc"
#include "mcp_luns.inc"
#include "muon.inc"
#include "muon_ntuple.inc"

c    Local variables

      data mutags/ 'pt', 'eta', 'phi','gen_pt','gen_eta',
     +             'hits','ndet','Energy0','Energy1',
     +             'p','x', 'y','z','id_mom','id_grand'/
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        
        write(mcp_llpt,1000) mcp_filegeo
 1000   format('muon_init: muon_detector geometry from file: ',a) 
        
        if (dbg_hist(jdbg_muon).ne.0) then
c        book histograms for checking this routine and detector volume...
  
         call hcdir('//PAWC',' ')
         call hmdir('Generated muons','S')
         call hbook1(10,'gen muon Momentum',250,0.,100.,0.)
         call hbook1(15,'gen muon pt',100,0.,20.,0.)
         call hbook1(20,'gen muon eta',100,-10.,10.,0.)
         call hbook1(30,'gen muon phi',100,0.,360.,0.)
         call hbook1(110,'accepted muon Momentum',250,0.,100.,0.)
         call hbook1(115,'accepted muon pt',100,0.,20.,0.)
         call hbook1(120,'accepted muon eta',100,-10.,10.,0.)
         call hbook1(130,'accepted muon phi',100,0.,360.,0.)
         call hcdir('//PAWC',' ')
c
         call hmdir('Offline muons','S')
         call hbook1(10,'offline muon Momentum',250,0.,100.,0.)
         call hbook1(15,'offline muon pt',20,0.,100.,0.)
         call hbook1(20,'offline muon eta',100,-10.,10.,0.)
         call hbook1(30,'offline muon phi',100,0.,360.,0.)
         call hbook1(110,'accepted muon Momentum',250,0.,100.,0.)
         call hbook1(115,'accepted muon pt',100,0.,20.,0.)
         call hbook1(120,'accepted muon eta',100,-10.,10.,0.)
         call hbook1(130,'accepted muon phi',100,0.,360.,0.)
        
         call hcdir('//PAWC',' ')
         call hcdir(hbk_topdir,' ')

         call hbookn(1000,'Muons',nmuvar,hbk_topdir,1000,mutags)

         call hcdir('//PAWC',' ')
c         call hs_reset_hbook_setup('//PAWC')
       endif   
    
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.4  1997/05/27 14:58:12  mcbride
c remove call to histoscope
c
c Revision 1.3  1997/04/04  20:30:04  garren
c add rcs log line
c
