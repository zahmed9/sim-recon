#ifndef TRACING_CONST_H
#define TRACING_CONST_H

/* ****************************************************************************
//  Parameters expressing mathematical and physical constants and unit
//  definitions
// ***************************************************************************
// AUTHOR: Paul Lebrun, back translated from c++
// PURPOSE: translation of const.inc
// DATE: Jul 16, 1998

// -------------------------------------------------------------
// WARNING: if you change this file, also make sure you change 
//            const.inc!
// ------------------------------------------------------------- 
*/

#include "c_fortran_types.h"

/****************************************************************************
      Size of standard floating point words
// ***************************************************************************
// !# bytes in default floating word
*/

#define FLOAT_BYTE 8
/* !# 32 bit words in default float */
#define FLOAT_WORD 2
/* !# bytes in default integeres word */
#define INT_BYTE 4
/* 32 bit words in default integer */
#define INT_WORD 1

/* ****************************************************************************
//     Mathematical constants
// ****************************************************************************
//!pi = 3.14...
// PI already defined in "math.h" */
#define kPI  3.1415926535897932
/* !2*pi */
#define TWOPI  2. * kPI
/* 
!1.0 in either single or double precision.
//!Useful as a 1st argument to sign() function
//!so that it has same type as DFLOAT 2nd arg.
*/
#define ONE  1.0
#define ROOT12 3.46410161513775439

/* ****************************************************************************
//     Definition of mks units according to the unit system employed here.
//     We use units of cm, nsec, GeV and Tesla.
//     Note: Only this section need be changed if different units are used.
// ****************************************************************************
//      DFLOAT unit_meter      !1 meter in our units
//      DFLOAT unit_sec        !1 second in our units
//      DFLOAT unit_ev         !1 eV in our units
//      DFLOAT unit_eq         !1 electron charge in our units
//      DFLOAT unit_tesla      !1 tesla in our units */
#define UNIT_METER  100.
#define UNIT_SEC    1.E9
#define UNIT_EV     1.E-9
#define UNIT_EQ     1.0
#define UNIT_TESLA  1.0

/* ****************************************************************************
//     Some physical constants expressed in mks system. They are NOT set up to
//     scale correctly with units so you will have to change them.
// ****************************************************************************
//      DFLOAT bfield_mks    !Unit bfield in mks units (needed for consistency)
//      DFLOAT clight        !Speed of light
//      DFLOAT c_b           !1/R(curvature) = c_b * Bfield / pt
//      DFLOAT c_ms          !Multiple scattering constant.
//                           !sig_theta = c_ms*sqrt(rad_length)/(p*beta) */
#define BFIELD_MKS 10000.
#define CLIGHT  2.99792458E1
#define C_B  -2.99792458E5
#define C_MS  0.0141

/* ****************************************************************************
//     Some particle masses.  They are set up to
//     scale correctly with units so you should not have to change them.
// ****************************************************************************
//      DFLOAT e_mass         !electron mass
//      DFLOAT mu_mass        !muon mass
//      DFLOAT pi_mass        !pion mass
//      DFLOAT k_mass         !kaon mass
//      DFLOAT p_mass         !proton mass
//      DFLOAT pi0_mass       !pi0 mass
//      DFLOAT ks0_mass       !kshort mass
//      DFLOAT n_mass         !neutron mass
//      DFLOAT lambda_mass    !lambda mass   */


#define E_MASS  0.51099907E6 * UNIT_EV
#define MU_MASS 105.658389E6 * UNIT_EV
#define PI_MASS 139.56995E6 * UNIT_EV
#define K_MASS  493.677E6 * UNIT_EV  
#define P_MASS  938.27231E6 * UNIT_EV
#define PI0_MASS  134.9764E6 * UNIT_EV
#define KS0_MASS  497.672E6 * UNIT_EV
#define N_MASS    939.56563E6 * UNIT_EV
#define LAMBDA_MASS  1115.683E6 * UNIT_EV
 

/* ***************************************************************************
//     The machine dependent representation of Fortran logical variables.
//     
// ***************************************************************************
*/

#if defined(sgi) || defined(AIX) || defined(sun) || defined(Linux)
#define FTN_TRUE  1
#define FTN_FALSE 0
#endif

#if defined(__osf__)
#define FTN_TRUE  -1
#define FTN_FALSE  0
#endif

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif


/* *************************************************************************
//     Numerical constants for values of ISTHEP defined inside MCFAST:
//     These codes identify paritcles which have undergone:
//     a) Secondary interactions.
//     b) Pair production
//     c) Bremstrahlung
//
// *************************************************************************
*/

#define ISTHEP_SEC_INT 25
#define ISTHEP_PAIR    26
#define ISTHEP_BREM    27

/*
   Dimension of stdhep common.  This must be maintained by hand in
   all of const.h, const.hh and const.inc
 */
#define MCF_NMXHEP 4000

/* ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:58:36  eugenio
// Initial revision
//
// Revision 1.10  1999/04/01 21:46:19  kutschke
// Remove supurious = from some defines.
//
 * Revision 1.9  1998/11/20  22:48:35  procario
 * Linux port Added Linux section makefiles Small Linux modes to code.
 *
 * Revision 1.8  1998/11/11  03:38:10  kutschke
 * Define MCF_NMXHEP, TRUE, FALSE. Fix embedded comments.
 *
 * Revision 1.7  1998/10/22  15:30:27  garren
 * add missing n_mass
 *
 * Revision 1.6  1998/10/21  21:32:36  mcbride
 * add particle masses to const include files
 *
 * Revision 1.5  1998/09/24  01:23:10  kutschke
 * Add parameters for MCFAST defined ISTHEP values.
 *
 * Revision 1.4  1998/09/10  23:07:54  kutschke
 * Add FTN_TRUE and FTN_FALSE.
 *
 * Revision 1.3  1998/08/06  21:05:50  bphyslib
 * merging changes from v4_0_0
 *
 * Revision 1.2  1998/07/16  20:17:33  bphyslib
 * merge from v4_0_0
 *
 * Revision 1.1.2.1  1998/07/16  19:03:55  bphyslib
 * the C versions
 *
// Revision 1.3  1998/02/16  00:45:56  mkl
// added ROOT12 constant (to reflect change in const.inc)
//
// Revision 1.2  1997/03/15  19:06:59  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed rcs comment headers from # to c.
// used cvs admin -c to change default rcs comment headers for .inc files.
//
// Revision 1.1  1997/03/14  22:50:37  mkl
// imported .hh files for equivalent .inc files for Martin Lohner's c++ tracing code
*/



#endif /* TRACING_CONST_H */
