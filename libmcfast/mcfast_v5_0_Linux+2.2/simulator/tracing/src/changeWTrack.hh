#if !defined(CHANGEWTRACK_H)
#define CHANGEWTRACK_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      ChangeWTrack
// 
// Description: add small amount (say 100microns) to WTrackStruct
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     June 27, 1997

// system include files

// user include files
#include "cc_fortran_types.hh"
#include "const.hh"
#include "wtrack_struct.hh"

// forward declarations

// extern "C" prototypes
extern const DFLOAT SMALLDISTANCE;

WTrackStruct 
addSmallDistance( const WTrackStruct& iWTrack );

DFLOAT 
addSmallDistance( const DFLOAT iDistance );

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.7  1998/08/11 16:59:17  mkl
// turn functions from inline into real functions
//
// Revision 1.6  1998/07/16  18:26:34  bphyslib
// sigh, it really is const.hh
//
// Revision 1.5  1998/07/15  16:40:45  garren
// rename const.hh to const.h
//
// Revision 1.4  1998/01/14  20:03:02  mkl
// test for p==0 when adding small distance
//
// Revision 1.3  1997/08/03  06:01:49  mkl
// small fixes
//
// Revision 1.2  1997/07/31  14:53:06  bphyslib
// minor changes
//
// Revision 1.1  1997/07/03  03:33:58  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* CHANGEWTRACK_H */

