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
#include <iostream.h>

// user include files
#include "changeWTrack.hh"

// forward declarations

// extern "C" prototypes

// 5 microns
const DFLOAT SMALLDISTANCE = 5E-6*UNIT_METER;

WTrackStruct 
addSmallDistance( const WTrackStruct& iWTrack )
{
   // make copy not to disturb original!
   WTrackStruct wtrack = iWTrack;

   // Move by small distance along track (else give back input wtrack)
   if( 0 != wtrack.p )
   {
      const DFLOAT smallAmount = SMALLDISTANCE / wtrack.p; 
      
      wtrack.x += wtrack.px * smallAmount;
      wtrack.y += wtrack.py * smallAmount;
      wtrack.z += wtrack.pz * smallAmount;
   }
   
   return wtrack;
}

DFLOAT 
addSmallDistance( const DFLOAT iDistance )
{
   // Move 5 microns along track
   const DFLOAT newDistance = iDistance + SMALLDISTANCE; 

   return newDistance;
}

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.2  1998/08/11 19:05:30  mkl
// change SMALLDISTANCE back to 5 microns
//
// Revision 1.1  1998/08/11  16:59:17  mkl
// turn functions from inline into real functions
//
//
//
