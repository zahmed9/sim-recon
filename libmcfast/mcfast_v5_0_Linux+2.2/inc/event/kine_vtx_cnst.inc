#include "const.inc"

C   Contains info for vertex constraints
C
C   The chisquare for the intersection of several tracks at an unknown space
C   point z is
C
C        chisq = (x-x0)(t) * Vx0(inv) * (x-x0) + 2*lam(t)*(D*x + E*z + d1),
C
C   If there are additional constraints on the vertex z (for example by
C   requiring that the vertex be on a certain plane or along a particular
C   line), the chisquare must be augmented by the term
C
C         2*alpha(t)*(H*z + h)
C

      structure /trk_cnst_s/
        DFLOAT d(7,2)   !Vertex constraint matrix for track parameters (7 x 2)
        DFLOAT d1(2)    !Constant part of vertex constraint (2)
        DFLOAT vd(2,2)  !Vertex [D * VX0 * D(t)](inv) (2 x 2)
        DFLOAT dvx(2,7) !D * VX0  for vertex constraints (2 x 7)
        DFLOAT lam0(2)  !Initial Lagrange multipliers for vertex constraints (2)
        DFLOAT lam(2)   !Lagrange multipliers for vertex constraints (2)
        DFLOAT e(3,2)   !constraint matrix for vertex (3 x 2)
        DFLOAT elam(3)  !E(t)*lam (2)
        DFLOAT vde(2,3) !VD*E for vertex constraint (2 x 3)
        DFLOAT eve(3,3) !E(t)*VD*E for vertex constraint  (3 x 3) 
      end structure
 
      structure /vtx_cnst_s/
  
        record /trk_cnst_s/ trk_cnst(max_trk)
        DFLOAT h(3,3)   !constraint matrix for vertex
        DFLOAT h1(3)    !Constant part of constraint on vertex
        DFLOAT vh(3,3)  !Covariance matrix for H  VH = [H * Vz * H(t)](inv)
        DFLOAT hvz(3,3) !H*Vz
        DFLOAT alpha(3) !Lagrange multipliers for H constraint
        DFLOAT zv(3)    !Vertex
 
      end structure
  
      record /vtx_cnst_s/ vtx_cnst
  
      common /vtx_cnst_c/ vtx_cnst
