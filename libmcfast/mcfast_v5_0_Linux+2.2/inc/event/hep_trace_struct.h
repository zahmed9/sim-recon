#ifndef HEP_TRACE_STRUCT_H
#define HEP_TRACE_STRUCT_H


/*

   Rob Kutschke, Oct. 20, 1998.

   Structure for pointing from HEPEVT tracks to detector hits. 

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change
            hep_trace_struct.inc !

   --------------------------------------------------------

*/

typedef struct Hep_trace_s {
        int nhit;           /* # of entries in hit_track list. */
        int first_hit;      /* First entry in hit_track list.  */
        int ntrace;         /* # of entries in trace list.     */
        int first_trace;    /* First entry in trace list.      */
} hep_trace_s;

#define HEP_TRACE_WORD sizeof(hep_trace_s)

#endif
