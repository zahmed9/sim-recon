*     __________________________________________________________________________
*
*     Author:        Curtis A. Meyer/ Scott Teige
*     Creation Date: 16 May 1998
*     Purpose:       Provide resolution parameters to the smearing routines
*                    newbeam, newgamma and newcharged for smearing of 4-vectors.
*
*     __________________________________________________________________________
*
      real       pi      
      Parameter (pi = 3.14159265354)
*
*        Beam_resol: Energy Resolution on the photon beam, sigma_p/p.        
*
      real       Beam_resol
      parameter (Beam_resol = 0.001)
*
*        Final state photon smearing is performed using:
*
*           sigma     Gam_stat
*           ----- =  ---------   + Gam_floor
*             E        sqrt(E)
*
      real       Gam_stat
      real       Gam_floor
*
      parameter (Gam_stat  = 0.050)
      parameter (Gam_floor = 0.020)
*
*        Final state charged particle smearing parameters:
*
*        delta_Z: How well do we measure the z--coordinate of a hit.
*
*                       sig_z
*           sig_theta = ------ * sqrt{[12(N-1)]/[N(N+1)]}
*                        L_z
*
      real       delta_Z
      parameter (delta_Z = 0.002)
*
*        delat_R: How well do we measure the r-phi coordinate of a hit.
*   
*                                sig_rf        720
*           sig_pt = ( pt**2 ) * ------- sqrt{------}
*                                eB R**2       N+4
*
*           where sig_rf is the r-phi resolution, R is the "radial"
*           length of the track, and N is the number of measurements.
*
      real       delta_R
*
      parameter (delta_R = 0.0002)
*
*        rmax_bore: The maximum radius at which we are sensitive to hits.
*        rmax_inst: Maximum instrumented radius in the solenoid.
*        tgtpos:    Distance from the upstream end of the magnet to the 
*                   target (meters).
*        ltot:      Total length of the solenoid (meters).
*
      real rmax_bore
      real rmax_inst
      real tgtpos
      real ltot
*
      parameter ( rmax_bore   = 0.925 )
      parameter ( rmax_inst   = 0.650 )
      parameter ( tgtpos      = 0.500 )
      parameter ( ltot        = 4.650 )
*
*        Dipole_angle: Angle at which the dipole takes over (radians).
*
      Real       Dipole_angle
      Parameter (Dipole_angle = 5.00*(pi/180.0))
*
*        Dipole_res: Resolution of total momentum in the dipole.
*
      Real       Dipole_res
*     Parameter (Dipole_res = 0.005)
*
*        X0_gas: Radiation length of chamber gas (ethane).
*
      Real       X0_gas
      Parameter (X0_gas = 340.0)
*
*        B_sol: Magnetic field of the solenoid (tesla).
*
      Real       B_sol
      Parameter (B_sol = 2.24)
*
*_________________________________________________________________________________