#ifndef CONST
#define CONST

******************************************************************************
*  Parameters expressing mathematical and physical constants and unit
*  definitions
******************************************************************************

* -------------------------------------------------------------
* WARNING: if you change this file, also change const.h and const.hh !!!!
* -------------------------------------------------------------

******************************************************************************
*     Size of standard floating point words
******************************************************************************
#define DFLOAT double precision
c               # bytes in default floating word
      integer FLOAT_BYTE
      parameter (FLOAT_BYTE = 8)
c               # 32 bit words in default float
      integer FLOAT_WORD
      parameter (FLOAT_WORD = 2)
c                 # bytes in default integer word
      integer INT_BYTE
      parameter (INT_BYTE = 4)
c                 # 32 bit words in default integer
      integer INT_WORD
      parameter (INT_WORD = 1)

******************************************************************************
*     Mathematical constants
******************************************************************************
c             pi = 3.14...
      DFLOAT pi
c            2*pi
      DFLOAT tpi
c            1.0 in either single or double precision.
c            Useful as a 1st argument to sign() function
c            so that it has same type as DFLOAT 2nd arg.
      DFLOAT ONE
c         sqrt(12.)
      DFLOAT root12
      parameter (pi = 3.1415926535897932)
      parameter (tpi = 2. * pi)
      parameter (ONE = 1.0)
      parameter (root12 = 3.46410161513775439 )

******************************************************************************
*     Definition of mks units according to the unit system employed here.
*     We use units of cm, nsec, GeV and Tesla.
*     Note: Only this section need be changed if different units are used.
******************************************************************************
c      1 meter in our units
      DFLOAT unit_meter
c        1 second in our units
      DFLOAT unit_sec
c         1 eV in our units
      DFLOAT unit_ev
c         1 electron charge in our units
      DFLOAT unit_eq
c      1 tesla in our units
      DFLOAT unit_tesla
      parameter (unit_meter = 100.)
      parameter (unit_sec   = 1.E9)
      parameter (unit_ev    = 1.E-9)
      parameter (unit_eq    = 1.0)
      parameter (unit_tesla = 1.0)

******************************************************************************
*     Some physical constants expressed in mks system. They are set up to
*     scale correctly with units so you should not have to change them.
******************************************************************************
c     Unit bfield in mks units (needed for consistency)
      DFLOAT bfield_mks
c         Speed of light
      DFLOAT clight
c            1/R(curvature) = c_b * Bfield / pt
      DFLOAT c_b
c           Multiple scattering constant.
c           sig_theta = c_ms*sqrt(rad_length)/(p*beta)
      DFLOAT c_ms
			    
      
      parameter (bfield_mks = unit_sec * unit_ev / unit_eq
     *                  / unit_meter**2 / unit_tesla)
      parameter (clight = 2.99792458E8 * unit_meter / unit_sec)
      parameter (c_b = -clight * bfield_mks)
      parameter (c_ms = 0.0141E9 * unit_ev)
      
******************************************************************************
*     Some particle masses.  They are set up to
*     scale correctly with units so you should not have to change them.
******************************************************************************
c         electron mass
      DFLOAT e_mass
c        muon mass
      DFLOAT mu_mass
c        pion mass
      DFLOAT pi_mass
c         kaon mass
      DFLOAT k_mass
c         proton mass
      DFLOAT p_mass
c         neutron mass
      DFLOAT n_mass

c       pi0 mass
      DFLOAT pi0_mass
c       Kshort mass
      DFLOAT ks0_mass
c    Lambda mass
      DFLOAT lambda_mass

      parameter (e_mass  = 0.51099907E6 * unit_ev)
      parameter (mu_mass = 105.658389E6 * unit_ev)
      parameter (pi_mass = 139.56995E6 * unit_ev)
      parameter (k_mass  = 493.677E6 * unit_ev)
      parameter (p_mass  = 938.27231E6 * unit_ev)
      parameter (n_mass  = 939.56563E6 * unit_ev)

      parameter (pi0_mass  = 134.9764E6 * unit_ev)
      parameter (ks0_mass  = 497.672E6 * unit_ev)
      parameter (lambda_mass  = 1115.683E6 * unit_ev)

C****************************************************************************
C
C     Numerical constants for values of ISTHEP defined inside MCFAST:
C     These codes identify paritcles which have undergone:
C     a) Secondary interactions.
C     b) Pair production
C     c) Bremstrahlung
C
      integer ISTHEP_SEC_INT
      integer ISTHEP_PAIR
      integer ISTHEP_BREM
      parameter ( ISTHEP_SEC_INT = 25 )
      parameter ( ISTHEP_PAIR    = 26 )
      parameter ( ISTHEP_BREM    = 27 )

C****************************************************************************
C
C     Dimension of stdhep common.  This must be maintained by hand in
C     all of const.inc, const.h, const.hh.
C
      integer MCF_NMXHEP
      parameter ( MCF_NMXHEP = 4000 )

c ======================================================================
c Comments, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:36  eugenio
c Initial revision
c
c Revision 1.10  2000/01/19 19:38:17  garren
c fix some ! comments which can cause problems for Linux user code
c
c Revision 1.9  1998/11/11  03:39:09  kutschke
c Define MCF_NMXHEP
c
c Revision 1.8  1998/10/22  15:30:27  garren
c add missing n_mass
c
c Revision 1.7  1998/10/21  21:32:37  mcbride
c add particle masses to const include files
c
c Revision 1.6  1998/09/24  01:23:19  kutschke
c Add parameters for MCFAST defined ISTHEP values.
c
c Revision 1.5  1998/07/16  18:49:54  bphyslib
c sigh, it really is const.hh
c
c Revision 1.4  1998/07/15  16:44:10  garren
c rename const.hh to const.h
c
c Revision 1.3  1997/12/05  21:25:54  kutschke
c Define root12.
c
c Revision 1.2  1997/03/14  22:50:37  mkl
c imported .hh files for equivalent .inc files for Martin Lohner's c++ tracing code
c

#endif
