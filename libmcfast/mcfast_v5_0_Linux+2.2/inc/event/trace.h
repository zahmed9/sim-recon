#ifndef TRACE_H
#define TRACE_H


/*

   Rob Kutschke, Sept 24, 1998.

   List of intersections of tracks with surfaces, either rplanes
   or zplanes.

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change 
            trace.inc !

   -------------------------------------------------------- 
*/

/*
   There are two versions of this file floating around in 
   different area.  This should make sure only one is picked up.
 */

#include "trace_struct.h"

#define trace_max 50000         /* Maximum number of trace points.       */
#define TRACE_MAX trace_max     /* Some old code wants this.             */

extern struct trace_par_c {
  int trace_num;                /* Number of trace points in this event. */
  int trace_num_dum;            /* Alignment dummy.                      */
  trace_s trace_par[trace_max];
} trace_par_c_;

/* 
   For historical reasons the first item in the structure was sometimes
   called by this name, which should now be considered obsolete in
   all user code.
*/

#define n_obj_trace_par trace_num

#endif
/*
 *  $Id$
 *
 *  $Log$
 *  Revision 1.1  2000/06/19 19:58:36  eugenio
 *  Initial revision
 *
 *  Revision 1.5  1999/04/01 22:27:13  mcbride
 *   increase size for BTeV
 *
 * Revision 1.4  1999/02/17  00:06:30  mcbride
 * up # of traces to 40000
 *
 * Revision 1.3  1998/11/11  21:35:14  kutschke
 * Remove last mods.
 *
 * Revision 1.2  1998/11/11  05:42:29  kutschke
 * Hack to get around multiple copies of this file.
 *
 * Revision 1.1  1998/09/25  02:43:32  kutschke
 * New file.  Generated from .inc version.
 *
 *
 */
