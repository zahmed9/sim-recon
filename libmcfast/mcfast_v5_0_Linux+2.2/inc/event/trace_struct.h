#ifndef TRACE_STRUCT_H
#define TRACE_STRUCT_H

/*

   Rob Kutschke, Sept 24, 1998.

   Description of the intersection of a track with an rplane or
   a zplane.

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change 
            trace_struct.inc !

   -------------------------------------------------------- 

*/

/*
    Protect against inclusion from the simulator/io/src area. 
    This needs to be fixed properly.
 */

#ifndef TRACE_MAX

#include "wtrack_struct.h"

typedef struct _trace_s {
  int hep;       /* Position of track in hepevt_           */
  int type;      /* Trace type (see trace_type.h)          */
  int plane;     /* Radial or z plane #                    */
  int hit;       /* # of hit in hit_track list (0 if none) */
  wtrack_s w;    /* Track parameters at the intersection   */
  double eta[3]; /* Direction cosines of normal to plane   */
  double path;   /* Total track length up to this hit      */
  double time;   /* Time at which track made hit           */
  double tau;    /* Proper flight time to intersection     */
  int material;  /* Position in material list              */
  int dummy;     /* Pad to align structure                 */
  double radl;   /* # of radiation lengths of material     */
  double dedx;   /* dE                                     */
} trace_s;

#endif

#endif
/*
 *  $Id$
 *
 *  $Log$
 *  Revision 1.1  2000/06/19 19:58:38  eugenio
 *  Initial revision
 *
 *  Revision 1.3  1999/11/17 16:54:08  mcbride
 *  added pad to align structure
 *
 * Revision 1.2  1998/11/11  05:42:25  kutschke
 * Hack to get around multiple copies of this file.
 *
 * Revision 1.1  1998/09/25  02:43:37  kutschke
 * New file.  Generated from .inc version.
 *
 *
 */
