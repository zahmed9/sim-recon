#ifndef TRACK_KINE_STRUCT_H
#define TRACK_KINE_STRUCT_H

/*  
   Track parametrization for general use (analysis, vertex fitting,
   kinematic fitting).

   -------------------------------------------------------
   WARNING: if you change this file, also make sure you change 
            track_kine_struct.inc.
   -------------------------------------------------------- 
*/

/*These parameters describe where the tracks come from*/

static const int jtrk_hep       1; /*Track comes from HEP common */
static const int jtrk_kine      2; /*Track comes from kinematic fitting */
static const int jtrk_central   3; /*Track comes from central fitted list */
static const int jtrk_forward   4; /*Track comes from forward fitted list */
static const int jtrk_offline   5; /*Track comes from offline fitted list */
static const int jtrk_anlcccsh  6; /*Track comes from ANLCCC shower list */
static const int jtrk_anlcxbg   7; /*Track comes from ANLCXB gamma list */
static const int jtrk_trigger   8; /*Track comes from trigger */
static const int jtrk_other     9;
 
#include "const.h"
#include "wtrack_struct.h"

typedef struct  _track_kine_s {
   wtrack_struct  w0;       /* Unconstrained track parameters*/
   wtrack_struct  w;        /* Track parameters after fit*/
   double mass;             /* Mass*/
   double cov[7][7];        /* Covariance matrix*/
   int    icov ;            /*  0 ==> covariance matrix not defined
                             *  1 ==> covariance matrix defined
                             *  2 ==> as 1, but no momentum information.*/
   int    hep;              /* Position of corresp. track in HEPEVT list*/
   int    origin;           /* Origin of track (see definitions above)*/
   int    pos;              /* Pos. of corresp. track in original list*/
   double nom_mass;         /* Nominal mass*/
   int    status ;          /* Status (0=unmeasured, 1=measured, 2=fixed)*/
   int    class;            /* User defined class*/
   int    pos_info ;        /* 0 ==>if position info not defined for track
                             * 1 ==>if position info defined for track*/
   int    fixed_mass;       /* 0 ==>if particle does not have fixed mass
                             * 1 ==>if particle has fixed mass */
   int    id;               /* Particle type */   
   int    dummy;            /* Pad to align structure */			     
}Track_kine_s; 

#endif

/*
 *  $Id$
 *
 *  $Log$
 *  Revision 1.1  2000/06/19 19:58:38  eugenio
 *  Initial revision
 *
 *  Revision 1.2  1999/11/17 16:54:09  mcbride
 *  added pad to align structure
 *
 * Revision 1.1  1998/09/15  04:21:34  kutschke
 * New file.
 *
 *
 */
