/************************************************
 * tof.h          TOF and Cerenkov PARAMETERS
 * 
 * This file contains the hardwired parameters
 * for the Hall D TOF & Cerenkov mc package. These parameters
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
#define HADRON_SHOWER 9


/* Old tracing code defines 
#define CENTRAL 1
#define FORWARD 2
#define TMCFAST_CENTRAL_TRACE 1
#define TMCFAST_FORWARD_TRACE 2
*****/

/******* USE THESE VALUES FOR THE NEW MCFAST TRACER */
#define CENTRAL 13
#define FORWARD 13



/* TMCFAST trace types must match those defined in TMCFastTOF.h 
#define TMCFAST_CENTRAL_TRACE 41
#define TMCFAST_FORWARD_TRACE 42
*/
/*
 *  locations of TOF (units are in cm)
 *       use r location for type=CENTRAL
 *       use z location for type=FORWARD
 *
 * IMPORTANT!! CTOF_R &  FTOF_Z MUST AGREE WITH THE VALUES IN the geo.db FILE!
 */
#define CTOF_R 65.0  /* rmin */
#define FTOF_Z 565.0 /* z0 - zlength/2 */

/* The production trace is the 
 * first trace in the trace list. It's
 * plane id is "0".
 */
#define PRODUCTION_PLANE 0
/*
 * Cerenkov Parameters (added 9 Apr 1999 PME)
 */
#define CERENKOV_Z 420.0



#endif
