#ifndef TRACING_CONST_HH
#define TRACING_CONST_HH

//******************************************************************************
//*  Parameters expressing mathematical and physical constants and unit
//*  definitions
//******************************************************************************
// AUTHOR: Martin Lohner
// PURPOSE: translation of const.inc
// DATE: Mar 14, 1997

// -------------------------------------------------------------
// WARNING: if you change this file, also make sure you change 
//            const.inc!
// -------------------------------------------------------------

#include "cc_fortran_types.hh"


//******************************************************************************
//*     Size of standard floating point words
//******************************************************************************
//!# bytes in default floating word
const integer FLOAT_BYTE = 8;
//!# 32 bit words in default float
const integer FLOAT_WORD = 2;
//!# bytes in default integeres word
const integer INT_BYTE = 4;
//!# 32 bit words in default integer
const integer INT_WORD = 1;

//******************************************************************************
//*     Mathematical constants
//******************************************************************************
//!pi = 3.14...
// PI already defined in "math.h"
const DFLOAT kPI = 3.1415926535897932;
//!2*pi
const DFLOAT TWOPI = 2. * kPI;
//!1.0 in either single or double precision.
//!Useful as a 1st argument to sign() function
//!so that it has same type as DFLOAT 2nd arg.
const DFLOAT ONE = 1.0;
const DFLOAT ROOT12 = 3.46410161513775439;

//******************************************************************************
//*     Definition of mks units according to the unit system employed here.
//*     We use units of cm, nsec, GeV and Tesla.
//*     Note: Only this section need be changed if different units are used.
//******************************************************************************
//      DFLOAT unit_meter      !1 meter in our units
//      DFLOAT unit_sec        !1 second in our units
//      DFLOAT unit_ev         !1 eV in our units
//      DFLOAT unit_eq         !1 electron charge in our units
//      DFLOAT unit_tesla      !1 tesla in our units
const DFLOAT UNIT_METER = 100.;
const DFLOAT UNIT_SEC   = 1.E9;
const DFLOAT UNIT_EV    = 1.E-9;
const DFLOAT UNIT_EQ    = 1.0;
const DFLOAT UNIT_TESLA = 1.0;

//******************************************************************************
//*     Some physical constants expressed in mks system. They are set up to
//*     scale correctly with units so you should not have to change them.
//******************************************************************************
//      DFLOAT bfield_mks     !Unit bfield in mks units (needed for consistency)
//      DFLOAT clight         !Speed of light
//      DFLOAT c_b            !1/R(curvature) = c_b * Bfield / pt
//      DFLOAT c_ms           !Multiple scattering constant.
//                            !sig_theta = c_ms*sqrt(rad_length)/(p*beta)

const DFLOAT BFIELD_MKS = UNIT_SEC * UNIT_EV 
                          / UNIT_EQ / UNIT_METER*UNIT_METER / UNIT_TESLA; 
const DFLOAT CLIGHT = 2.99792458E8 * UNIT_METER / UNIT_SEC;
const DFLOAT C_B = -CLIGHT * BFIELD_MKS;
const DFLOAT C_MS = 0.0141E9 * UNIT_EV;

//******************************************************************************
//*     Some particle masses.  They are set up to
//*     scale correctly with units so you should not have to change them.
//******************************************************************************
//      DFLOAT e_mass         !electron mass
//      DFLOAT mu_mass        !muon mass
//      DFLOAT pi_mass        !pion mass
//      DFLOAT k_mass         !kaon mass
//      DFLOAT p_mass         !proton mass
//      DFLOAT pi0_mass       !pi0 mass
//      DFLOAT ks0_mass       !kshort mass
//      DFLOAT n_mass         !neutron mass
//      DFLOAT lambda_mass    !lambda mass

const DFLOAT E_MASS  =    0.51099907E6 * UNIT_EV;
const DFLOAT MU_MASS = 105.658389E6 * UNIT_EV;
const DFLOAT PI_MASS = 139.56995E6 * UNIT_EV;
const DFLOAT K_MASS  =  493.677E6 * UNIT_EV;
const DFLOAT P_MASS  =  938.27231E6 * UNIT_EV;
const DFLOAT PI0_MASS  =  134.9764E6 * UNIT_EV;
const DFLOAT KS0_MASS  =  497.672E6 * UNIT_EV;
const DFLOAT N_MASS =  939.56563E6 * UNIT_EV;
const DFLOAT LAMBDA_MASS =  1115.683E6 * UNIT_EV;

//****************************************************************************
//*     The machine dependent representation of Fortran logical variables.
//*     
//****************************************************************************

#if defined(sgi) || defined(AIX) || defined(sun) 
const Logical FTN_TRUE  = 1;
const Logical FTN_FALSE = 0;
#endif

#if defined(__osf__)
const Logical FTN_TRUE  = -1;
const Logical FTN_FALSE =  0;
#endif

//**************************************************************************
//     Numerical constants for values of ISTHEP defined inside MCFAST:
//     These codes identify paritcles which have undergone:
//     a) Secondary interactions.
//     b) Pair production
//     c) Bremstrahlung
//
//**************************************************************************

const integer ISTHEP_SEC_INT = 25;
const integer ISTHEP_PAIR    = 26;
const integer ISTHEP_BREM    = 27;

//**************************************************************************
//
//  Dimension of stdhep common.  This must be maintained by hand in
//  all of const.h, const.hh and const.inc
//
//**************************************************************************
const integer MCF_NMXHEP = 4000;



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:58:36  eugenio
// Initial revision
//
// Revision 1.8  1998/11/11 03:38:36  kutschke
// Define MCF_NMXHEP.
//
// Revision 1.7  1998/10/21  22:55:01  mcbride
// fixed missing =
//
// Revision 1.6  1998/10/21  21:32:36  mcbride
// add particle masses to const include files
//
// Revision 1.5  1998/09/24  01:23:14  kutschke
// Add parameters for MCFAST defined ISTHEP values.
//
// Revision 1.4  1998/09/10  23:07:57  kutschke
// Add FTN_TRUE and FTN_FALSE.
//
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
//



#endif // TRACING_CONST
