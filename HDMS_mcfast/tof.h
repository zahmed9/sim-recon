/************************************************
 * tof.h          TOF PARAMETERS
 * 
 * This file contains the hardwired parameters
 * for the Hall D TOF mc package. These parameters
 * are used in usr_dump()
 *
 * Paul Eugenio
 * Carnegie Mellon University
 * 28 Oct 98
 **********************************************/
#ifndef TOF_CHEADER
#define TOF_CHEADER

#include"trace.h"
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 *  IMPORTANT!! IMPORTANT!! IMPORTANT!! IMPORTANT!! IMPORTANT!! 
 *
 * CTOF_R &  FTOF_Z MUST AGREE WITH THE VALUES IN the geo.db FILE!
 *
 * IMPORTANT!! IMPORTANT!! IMPORTANT!! IMPORTANT!! IMPORTANT!!
 *!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 */

/*
 * Trace types
 */
#define PRODUCTION 4
#define CENTRAL 1
#define FORWARD 2

/*
 *  locations of TOF (units are in cm)
 *       use r location for type=CENTRAL
 *       use z location for type=FORWARD
 *
 * IMPORTANT!! CTOF_R &  FTOF_Z MUST AGREE WITH THE VALUES IN the geo.db FILE!
 */
#define CTOF_R 75.0  /* rmin */
#define FTOF_Z 450.0 /* z0 - zlength/2 */

/* The production trace is the 
 * first trace in the trace list. It's
 * plane id is "0".
 */
#define PRODUCTION_PLANE 0


#endif
