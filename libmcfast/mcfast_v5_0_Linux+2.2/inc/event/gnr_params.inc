******************************************************************************
*  Parameters to generate an event internally. Each particle is generated
*  according to an exponential in Pt and flat in eta.
*
*  4-30-97, Julia Yarba : all reals -> DFLOAT
*
******************************************************************************

#include "const.inc"

      integer gnr_maxtype
      parameter (gnr_maxtype = 30)
 
      integer gnr_ntype    !# of different particle types
      integer gnr_type_list!List of particle types (PDG code)
      DFLOAT gnr_type_masses !Particle mass per type
      DFLOAT gnr_type_probs  !Prob for having each particle type
      logical gnr_fix_mult !TRUE  ==> Number of tracks is fixed
      
      DFLOAT gnr_avetrk      !Average # of tracks to generate
                           !FALSE ==> # of tracks gen. by poisson
      DFLOAT gnr_ptmin       !pt min to generate
      DFLOAT gnr_ptmax       !pt max to generate
      DFLOAT gnr_etamin      !eta min to generate
      DFLOAT gnr_etamax      !eta max to generate
      DFLOAT gnr_phimin      !phi min to generate
      DFLOAT gnr_phimax      !phi max to generate
      DFLOAT gnr_slope       !f(pt) = exp(-slope*pt)
      DFLOAT gnr_vtx         !Vertex center
      DFLOAT gnr_dvtx        !Vertex sigmas

      common/gnr_params1/
     *  gnr_ntype,
     *  gnr_type_list(gnr_maxtype),
     *  gnr_fix_mult

      common/gnr_params2/
     *  gnr_type_masses(gnr_maxtype),
     *  gnr_type_probs(gnr_maxtype),
     *  gnr_avetrk,
     *  gnr_ptmin,
     *  gnr_ptmax,
     *  gnr_etamin,
     *  gnr_etamax,
     *  gnr_phimin,
     *  gnr_phimax,
     *  gnr_slope,
     *  gnr_vtx(3),
     *  gnr_dvtx(3)
