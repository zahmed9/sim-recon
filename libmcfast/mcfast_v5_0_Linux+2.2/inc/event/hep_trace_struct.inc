#ifndef HEP_TRACE_STRUCT
#define HEP_TRACE_STRUCT

c
c   Rob Kutschke, Oct. 2o, 1998.
c
c   Structure for pointing from HEPEVT tracks to detector hits. 
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change
c            hep_trace_struct.h !
c
c   --------------------------------------------------------
c

      structure /hep_trace_s/
        integer nhit           !# of entries in hit_track list
        integer first_hit      !first entry in hit_track list
        integer ntrace         !# of entries in trace list
        integer first_trace    !first entry in trace list
      end structure

      integer HEP_TRACE_WORD
      PARAMETER (HEP_TRACE_WORD = 4)
#endif
