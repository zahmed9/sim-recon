#ifndef SHOWER_TRACE_STRUCT
#define SHOWER_TRACE_STRUCT

c   Shower description in W form

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change
c            shower_trace_struct.hh!
c -------------------------------------------------------------
 
#include "wtrack_struct.inc"

      structure /shower_trace_struct/
        integer hep           ! pointer to particle which initiates shower
        DFLOAT  E_original    ! energy at shower start
        DFLOAT N_radlen_pass ! # of RadLen passed by shower (it does NOT
c                              ! include pass while particle behaves as MIP)
        record /wtrack_struct/ w 
      end structure
      


c ======================================================================
c Comments, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:38  eugenio
c Initial revision
c
c Revision 1.4  2000/01/19 19:38:22  garren
c fix some ! comments which can cause problems for Linux user code
c
c Revision 1.3  1997/03/15  19:07:00  mkl
c moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
c fixed rcs comment headers from # to c.
c used cvs admin -c to change default rcs comment headers for .inc files.
c
c Revision 1.2  1997/03/14  22:50:38  mkl
c imported .hh files for equivalent .inc files for Martin Lohner's c++ tracing code
c

#endif      
      
