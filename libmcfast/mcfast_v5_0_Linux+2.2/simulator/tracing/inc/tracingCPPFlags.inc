#if !defined(TRACING_TRACINGCPPFLAGS_H)
#define TRACING_TRACINGCPPFLAGS_H
#if 0 /* commented out so that inclusion into fortran works */
// -*- Fortran C++ -*-
//
// Package:     Tracing
// Module:      tracingCPPFlags
// 
// Description: contains CPP preprocessor flags for 
//              conditional compilation
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Nov 12, 1997
#endif

#undef OLD_ZSIXY  /* turn on old pixel representation vs new siz_rect */
#define SPEED     /* go for speed rather than comparisons with fortran:
                     the results will still be OK!!!!! */

#if 0 /* commented out so that inclusion into fortran works */
// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:30  eugenio
// Initial revision
//
// Revision 1.4  1998/02/18 05:11:23  mkl
// new SPEED cpp parameter to set either for speed or comparisons with Fortran
//
//Revision 1.3  1998/02/17  05:11:25  mkl
//turned OLD_ZSIXY handling
//
//Revision 1.2  1997/11/12  23:34:54  mkl
//c++-style rcs comments
//
// Revision 1.1  1997/11/12  23:27:49  mkl
// a place for cpp compile-time flags
//
//
#endif

#endif /* TRACING_TRACINGCPPFLAGS_H */
