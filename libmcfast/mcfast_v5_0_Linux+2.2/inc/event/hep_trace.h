#ifndef HEP_TRACE_H
#define HEP_TRACE_H

#include "const.h"
#include "hep_trace_struct.h"

/*

   Rob Kutschke, Oct. 20, 1998.

   Information about each HEPEVT track during its trace through the detector

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change
            hep_trace.inc !

   --------------------------------------------------------

*/

extern struct Hep_trace_c {
  int n_obj_hep_trace;                 /* # used slots in hep_trace.        */
  int idm_trc;                         /* Alignment dummy.                  */
  hep_trace_s hep_trace[MCF_NMXHEP];   /* Indices into trace and hit lists. */
}  hep_trace_c_;


#endif
