      subroutine newcharged(p)
*
*        Purpose: Take a 4-vector for a charged particle (p,E) and
*                 smear it according to defined resolutions.
*

*        Modified: 14 May 1998
*
*
      real   pi      
      Parameter (pi=3.1415927)
*
      Real   Dipole_angle
      Parameter (Dipole_angle = 8.50*pi/180.0)
*
      real   delta_Z /0.002/     ! Resolution of the chambers (meters)
      real   delta_R /0.0002/    ! Resolution in r-phi
      real   L_z     /1.000/     ! Path length of the tracks  (meters)
      real   X0      /340./      ! Radiation length of Ethane (meters)
      real   B       /2.24/      ! Solenoid field (tesla)
      real   rmax    /0.925/     ! Bore radius(meters)
      real   ltot    /3.20/      ! Total length of solenoid (meters)
      real   tgtpos  /1.00/      ! distance from upstream end of mag. to tgt.
      real   L_scat              ! path length of the track
      real   N_turns             ! how many loops?
      real   N_turns_end
      real   N_turns_bor
*
*        sig_p: delta_pt/pt
*        sig_t: delta_theta/theta
*
      real   sig_p
      real   sig_t
      real   the_new
      real   pt_new
*
      logical enter /.false./
      save    enter
*
      real p(4),msq,pmagsq,ptsq
*
*     ****************************************************
*
*
*        convert from GeV to meters.
*
      if(.not.enter) then
         enter=.true.
         Q = 2. * pi / (0.3*B) 
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
*           angle is less than 8.5 degrees, assume reconstruction by
*           the dipole spectrometer with 1/2% resolution on the total
*           momentum. Additionally, assume that theta is measured
*           perfectly. 
*
         pnew = pmag * (1.00 + 0.005 * gausran(dummy) )
*
         do 100 i = 1,3
            p(i) = p(i) * pnew / pmag
 100     continue
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
*           angle is greater than 8.5 degrees, assume reconstruction by
*           solenoidal spectrometer. Get the track radius.
*
         radius = pt / (0.3*B)
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
*           Get the path length in z of the track:
*
         Z_path = min( (rmax / tan(theta)),abs(z_final) )
*
*           In the case where we are near 90 degrees, fix the error
*           in theta to a finite number. We treat the sqrt-factor
*           as simply one here.
* 
*                       sig_z
*           sig_theta = ------ * sqrt{[12(N-1)]/[N(N+1)]}
*                        L_z
*
*
         If ( Z_path .le. 57.3*Delta_z ) Then
            sig_t = (0.01745)**2
         Else
            sig_t = (Delta_z / Z_path)**2
         Endif
*
*           Next compute the length, L_scat to put into multiple
*           scattering.
*
         if( radius .le. ( 0.5 * rmax ) ) then
*
*              track cannot reach bore, must escape via an end.
*              calculate the track length used in the multiple
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
            if ( nturns .le. 1. ) then
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
*              track may reach bore, may hit an end.
*              Calculate how many radians to hit the end,
*              how many radians to hit the bore.
*
            If ( P(3) .EQ. 0.0 ) Then
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
               N_turns_bor = (2.*radius**2-rmax**2) / (2.*radius)
               IF ( Abs(N_turns_bor) .gt. 1.0) Then
                  N_turns_bor = 0
               Else
                  N_turns_bor = 
     &            acos( (2.*radius**2-rmax**2) / (2.*radius) )

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
*           Now we want to compute the error in P_T
*
*        first two terms are chamber resolution,
*        third is multiple scattering.
*
         R_path = Min(rmax,abs(3.50*tan(theta)))
*
         sig_p = 8.0 * Ptsq * Delta_R / (0.30 * B * R_path**2 ) 
*
*           Generate a smeared transverse momentum. However, limit
*           ourselves to at most a 90% error.
*
 300     pt_new = sig_p * gausran(dummy)
         If ( abs(pt_new) .gt. 0.9*pt ) Goto 300
         pt_new = pt + pt_new
*
         sig_t = sig_t
     &         + ( 0.0136 * p(4) * sqrt( L_scat/X0 ) / pmagsq )**2 
         sig_t = sqrt(sig_t)
*
 400     th_new = sig_t * gausran(dummy)
         if ( ( th_new + theta ) .lt. 0.0 ) goto 400
*
         th_new = theta + th_new
*
         p(1) = p(1) * pt_new/pt
         p(2) = p(2) * pt_new/pt
         p(3) = pt_new / tan(th_new)
         p(4) = sqrt ( p(1)**2 + p(2)**2 + p(3)**2 + msq )
*
      endif
*
      return
      end
