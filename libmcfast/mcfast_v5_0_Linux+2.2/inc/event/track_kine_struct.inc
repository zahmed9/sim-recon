#ifndef TRACK_KINE_STRUCT
#define TRACK_KINE_STRUCT

c     Track parametrization for general use (analysis, vertex fitting,
c     kinematic fitting)

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change 
c          track_kine_struct.h !
c -------------------------------------------------------------


c  modified 10/6/94 A.Boehnlein, added w0,class,pos_info,fixed_mass,id
c  modified 10/31/94 ASB added CLEO like track definitions 
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    These parameters describe where the tracks come from

      integer jtrk_hep,     jtrk_kine,     jtrk_central, jtrk_forward
      integer jtrk_offline, jtrk_anlcccsh, jtrk_anlcxbg
      integer jtrk_trigger, jtrk_other

      parameter (jtrk_hep = 1)		!Track comes from HEP common
      parameter (jtrk_kine = 2)		!Track comes from kinematic fitting
      parameter (jtrk_central = 3)	!Track comes from central fitted list
      parameter (jtrk_forward = 4)	!Track comes from forward fitted list
      parameter (jtrk_offline = 5)	!Track comes from offline fitted list
      parameter (jtrk_anlcccsh= 6)      !Track comes from ANLCCC shower list
      parameter (jtrk_anlcxbg = 7)      !Track comes from ANLCXB gamma list
      parameter (jtrk_trigger = 8)      !Track comes from trigger.
      parameter (jtrk_other   = 9)      !
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Only the first 7 parameters are used in fitting.

#include "const.inc"
#include "wtrack_struct.inc"

      structure /track_kine_s/
        record /wtrack_struct/ w0 !unconstrained track parameters
        record /wtrack_struct/ w  !Track parameters after fit
        DFLOAT mass               !Mass
        DFLOAT cov(7,7)           !Covariance matrix
        integer icov              !0 ==> covariance matrix not defined
c                                  !1 ==> covariance matrix defined
c                                  !2 ==> as 1, but no momentum information.
        integer hep               !Position of corresp. track in HEPEVT list
        integer origin            !Origin of track (see definitions above)
        integer pos               !Pos. of corresp. track in original list
        DFLOAT nom_mass           !Nominal mass
        integer status            !Status (0=unmeasured, 1=measured, 2=fixed)
        integer class             !user defined class       
        integer pos_info          !0 ==>if position info not defined for track
c                                  !1 ==>if position info defined for track
        integer fixed_mass        !0 ==>if particle does not have fixed mass
c                                  !1 ==>if particle has fixed mass
        integer id                !particle type 
	integer dummy             !pad to align structure                          
      end structure
#endif
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:58:38  eugenio
cInitial revision
c
cRevision 1.6  2000/01/19 19:38:23  garren
cfix some ! comments which can cause problems for Linux user code
c
c Revision 1.5  1999/11/17  16:54:09  mcbride
c added pad to align structure
c
c Revision 1.4  1998/09/15  04:30:28  kutschke
c Update comments. Add new parameters.
c
c Revision 1.3  1997/03/24  17:36:46  kutschke
c Add comment for icov=2
c
