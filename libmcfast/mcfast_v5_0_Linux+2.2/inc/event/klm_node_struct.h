#ifndef KLM_NODE_STRUCT_H
#define KLM_NODE_STRUCT_H

/*

   Rob Kutschke, Oct. 22, 1998.

   The input to the Kalman filter is a doubly linked list of "nodes".
   This defines the structure of one "node".

   A node represents such things as:
     1) The point at which to start the fit.
     2) The point at which to report the fit.
     3) An extra point put in because of step limitations from
        the magnetic field.
     4) A scattering surface.
     5) A measurement.
     6) Some combinations of the above.

   The above possibilities are distinguished by the information
   found by dereferencing the tp and hp.

   If the output pointer, op, is non-NULL, then the fitter will
   store some output specifically related to this point, such
   as residuals at the location of the pointer.

  Notes:
  (1) The user is responsible for initializing the pointer KPIptr.
      If it is NULL, no output will be written to it.
      At present it is just a place holder because the code to fill
      it has not yet been written.
  (2) The origin variable is used to indicate who created this node.
      The possible values are suggestions.  It is anticipated we need
      to keep this history to help sort out who is responsible for
      freeing what memory.

 */


#include "trace_struct.h"
#include "hit_track_struct.h"
#include "klm_smooth_struct.h"
#include "bfield_struct.h"

typedef struct Klm_node_s *Kptr;

typedef struct Klm_node_s {
   Kptr          next;     /* Pointer to next node.                        */
   Kptr          prev;     /* Pointer to previous node.                    */
   trace_s      *tp;       /* Pointer to trace point information.          */
   hit_trk_s    *hp;       /* Pointer to hit information.                  */
   Sptr          sp;       /* Pointer to output of fit for this point.     */
   bFieldStruct *bf;       /* Pointer to magnetic field for outwards step. */
   int        num;         /* Sequential number.                           */
   int        exclude_hit; /* Exclude hit information from fit.            */
   int        origin;      /* See note (2).                                */
} klm_node_s;

/* Values for the origin variable. */
enum { KF_ORIGIN_MCFAST, KF_ORIGIN_TRIGGER, KF_ORIGIN_USER };

#endif
