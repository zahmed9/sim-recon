      subroutine newcharged(p)
*
*        Purpose: Take a 4-vector for a charged particle (p,E) and
*                 smear it according to defined resolutions.
*

      Implicit None
*
      Real   p(4)
*
      Include "det_resol.h"
*
      Integer i
*
*        pt:     Transverse Momentum
*        ptsq:   Transverse Momentum Squared
*        pt_new: Smeared transverse momentum
*        pmag:   Total Momentum
*        pmagsq: Total Momentum squared.
*        pnew:   Smeared total momentum.
*        msq:    Particle Mass squared.
*
      real pt , ptsq , pt_new , pmag , pmagsq , pnew , msq
*
*        theta:   Angle of track from beam direction.
*        the_new: Smeared Theta
* 
      real theta , the_new
*
*        radius: radius if curvature of the track
*        Z_path: Path length of the track in Z
*        R_path: Path length of the track in R
*        L_scat: path length of the track for multiple scattering.
*        Z_final:
*        Z_one:  z coordinate at which we get our first hit.
*
      real radius , Z_path , R_path , L_scat , Z_final , Z_one
*
*        N_turns:     How amny turns
*        N_turns_end: How many turns to the end of the magnet
*        N_turns_bor: How many turns to the magnet bore
*
      real   N_turns           
      real   N_turns_end
      real   N_turns_bor
*
*        sig_p: delta_pt/pt
*        sig_t: delta_theta/theta
*
      real   sig_p , sig_t
*
*
*
      real     gausran,dummy
      external gausran
*
*             2 pi
*        Q = -----
*             eB
*
      Real Q
      Save Q
*
*       L_first: Control initialization upon first call.
*
      logical L_first 
      save    L_first
*
      Data    L_first /.True./
      Data    Q       / 0.0 /
*
*     ****************************************************
*
*
*        convert from GeV to meters.
*
      if ( L_first ) then
         Q = 2. * pi / (0.3*B_sol) 
         L_first = .False.
      endif
*
*        Compute the transverse momentum, total momentum, 
*        particle mass and angle from the beam, theta.
*

      ptsq   = p(1)**2 + p(2)**2
      pmagsq = ptsq + p(3)**2
      pt     = sqrt(ptsq)
      msq    = p(4)**2 - pmagsq
c
c     calculate the angle to the z-axis
c
      pmag = sqrt( max(0.0,pmagsq) )
*
      If ( pmag .le. 0.0 ) then
         theta = 0.0
      else
         theta = acos(p(3)/pmag)
      endif
*
*   #################
*---# Dipole Region #
*   #################
*
*
      if ( theta .le. Dipole_Angle ) then
*
*           The track is detected in the dipole if we are inside
*           Dipole_Angle. In this case smear the total momentum
*           using the Dipole_res value. We also will assume that
*           theta is measured perfectly here.
*
 100     pnew = pmag * (1.00 + Dipole_res * gausran(dummy) )
         If ( pnew .le. 0.0 ) Goto 100
*
         do 200 i = 1,3
            p(i) = p(i) * pnew / pmag
 200     continue
*
*           Set energy to match the particle.
*
         p(4) = sqrt ( pnew**2 + msq )
*
*
      else
*
*   #############################
*---# Pure Solenoid Measurement #
*   #############################
*
*           The angle is greater than Dipole_Angle, assume reconstruction 
*           by the solenoidal spectrometer.
*                                           P_T
*           The radius of the track is  r = ---
*                                           eB
*
         radius = pt / (0.3*B_sol)
*
*           figure out which end of the magnet it should  hit, is it going
*           forward or backwards? (Might hit something before that)
*
         if(p(3).lt.0.) then
            z_final = -tgtpos     
         else
            z_final = ltot - tgtpos 
         endif
*
*           Get the path length in z of the track:  tan(theta) = r/z,
*           but if we get to rmax_inst, then we no longer get any
*           z measurements:
*
*           rmax_inst / tan(theta) == z length where we leave instrumentation.
*           abs(z_final)           == Exit the ends of the magnet.
*
         Z_path = min( abs(rmax_inst*cos(theta)/sin(theta)) 
     &               , abs(z_final))
         Z_one  = abs(rlyr1*cos(theta)/sin(theta))
*
*           We use the z-path length in conjunction with the z-resolution
*           to compute the error in theta.
*
*                       sig_z
*           sig_theta = ------ * sqrt{[12(N-1)]/[N(N+1)]}
*                        L_z
*
*           In the case where we are near 90 degrees, fix the error
*           in theta to a finite number. We treat the sqrt-factor
*           as simply one here. This can be improved as we determine
*           more precisely what the chamber spacing is.
*
         If ( (Z_path-Z_one) .le. 57.3*Delta_z ) Then
*
            sig_t = (0.01745)**2
*
         Else
*
            sig_t = (Delta_z / (Z_path-Z_one) )**2
*
         Endif
*
*           Now we want to compute the error in P_T. The formula for a
*           set of equally spaced measurements of fixed r-phi resolution
*           is:
*   
*                                sig_rf        720
*           sig_pt = ( pt**2 ) * ------- sqrt{------}
*                                eB R**2       N+4
*
*           where sig_rf is the r-phi resolution, R is the "radial"
*           length of the track, and N is the number of measurements.
*
*           Compute the "radial" length of the track. This is at most
*           rmax_inst, but could be limited to Z_path * tan(theta).
*           To avoid divide-by-zero, we make sure the radius never
*           gets smaller than 1cm.
*
         R_path = Min ( rmax_inst , abs ( Z_path * tan(theta) ) )
         R_path = Max ( 0.01 , R_path-rlyr1 )
*
*           Compute sig_p. Note that the "7" is assuming that N=10. This
*           can also be improved as we understand the geometry better.
*
         sig_p = 7.0 * Ptsq * Delta_R / (0.30 * B_sol * R_path**2 ) 
*
*           Generate a smeared transverse momentum. However, limit
*           ourselves to at most a 90% error.
*
 300     pt_new = sig_p * gausran(dummy)
         If ( abs(pt_new) .gt. 0.9*pt ) Goto 300
         pt_new = pt + pt_new
*
*           Next compute the length, L_scat to put into multiple
*           scattering. We need to worry about the instrumented
*           radius here, and assume that anything that wraps
*           back in is ignored.
*
         if( radius .le. ( 0.5 * rmax_inst ) ) then
*
*              Track will not get out of the instrumented region.
*              Calculate the track length used in the multiple
*              scattering contribution, assume we use one turn
*              for particle reconstruction. There are several
*              special cases. If p_z = 0, then we are stuck,
*              and in principal will loose the track. 
*
            IF ( p(3) .eq. 0.0 ) Then
               N_turns = 1.0
            ElseIf ( radius .eq. 0.0 ) Then
               N_turns = 0.0
            Else
               N_turns = ( pt / p(3) ) * (z_final / radius) / (2.*pi)
            ENDIF
*
            if ( N_turns .le. 1. ) then
*
*                 particle escapes (fore or aft) before going around once
*
               L_scat = N_turns * Q * pmag
*
            else
*
*                 particle goes around more than once before escaping,
*                 assume only the hits from the first turn are used
*                 for reconstruction.
*
               L_scat = Q * pmag
*
            endif
*
         else
*
*              The track can get outside the instrumented resion. It may 
*              reach the bore or may hit an end.
*              Calculate how many radians to hit the end,
*              how many radians to hit the bore.
*
            If ( p(3) .eq. 0.0 ) Then
               N_turns_end = 1.0
            ElseIf ( radius .eq. 0.0 ) Then
               N_turns_end = 0.0
            Else
               N_turns_end = (pt/p(3)) * (z_final/radius)
            Endif
*
            IF ( radius .eq .0.0) Then
               N_turns_bor = 0.0
            Else
               N_turns_bor = (2.*radius**2-rmax_inst**2) / (2.*radius)
               IF ( Abs(N_turns_bor) .gt. 1.0) Then
                  N_turns_bor = 1.0
               Else
                  N_turns_bor = 
     &            acos( (2.*radius**2-rmax_inst**2) / (2.*radius) )

               Endif
            Endif
*
*              Whichever is smaller, happens.
*
            N_turns = min ( N_turns_end , N_turns_bor)
*
*           number of turns must be less than 0.5 (geometric argument)
*
            L_scat = N_turns * Q*pmag / (2.*pi)
*
         endif
*
*           Add the (sig_t)**2 from the z-measurement to theta error
*           from multiple scattering.
*
         sig_t = sig_t
     &         + ( 0.0136 * p(4) * sqrt( L_scat/X0_gas ) / pmagsq )**2 
*
         sig_t = sqrt(sig_t)
*
*           Compute the modified theta. We pull a bit of a cheat here in that
*           we do not let theta get negative or larger than pi.
*
 400     the_new = theta + sig_t * gausran(dummy)
         if ( ( the_new .lt. 0.0 ) .or. ( the_new .gt. pi  ) ) goto 400
*
*           Compute the smeared momentum vector.
*
         p(1) = p(1) * pt_new/pt
         p(2) = p(2) * pt_new/pt
         p(3) = pt_new / tan(the_new)
         p(4) = sqrt ( p(1)**2 + p(2)**2 + p(3)**2 + msq )
*
      endif
*
      return
      end
