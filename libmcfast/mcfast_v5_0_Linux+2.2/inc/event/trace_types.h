#ifndef TRACE_TYPE_H
#define TRACE_TYPE_H

/*
     Rob Kutschke, Sept 24, 1998.

     Definitions of trace types.

    -------------------------------------------------------

    WARNING: if you change this file, also make sure you change 
             trace_types.inc !

    -------------------------------------------------------- 

*/


#define jtrace_rplane    1   /* Radial plane             */
#define jtrace_zplane    2   /* Z plane                  */
#define jtrace_cone      3   /* Cone                     */
#define jtrace_prod      4   /* Production               */
#define jtrace_decay     5   /* Decay in flight          */
#define jtrace_pair      6   /* Pair production          */
#define jtrace_absorb    7   /* Absorption               */
#define jtrace_calor     8   /* Calorimeter face         */
#define jtrace_shower    9   /* Shower conversion point  */
#define jtrace_dummy    10   /* Dummy point              */
#define jtrace_scat     11   /* Scattering event         */

#endif
/*
 *  $Id$
 *
 *  $Log$
 *  Revision 1.1  2000/06/19 19:58:38  eugenio
 *  Initial revision
 *
 *  Revision 1.1  1998/09/25 02:43:44  kutschke
 *  New file.  Generated from .inc version.
 *
 *
 */
