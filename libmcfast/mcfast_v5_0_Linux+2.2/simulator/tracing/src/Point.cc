// -*- C++ -*-
//
// Package:     Tracing
// Module:      Point
// 
// Description: 3-DIM space Point
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     June 25, 1997

// system include files

// user include files
#include "Point.hh"
#include "wtrack_struct.hh"

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
Point::Point( const DFLOAT x, const DFLOAT y, const DFLOAT z )
   : Vector( x, y, z )
{
}

Point::Point( const WTrackStruct& wtrack )
   : Vector( wtrack.x, wtrack.y, wtrack.z )
{
}

//Point::Point( const Point& )
//{
//}

Point::~Point()
{
}

//
// assignment operators
//
//const Point& Point::operator=( const Point& volume )
//{
//}

//
// member functions
//

//
// const member functions
//

// I/O
void
Point::printOn( ostream& str ) const
{
   str << "\nPoint( " 
       << x() << ", " 
       << y() << ", " 
       << z() 
       << " )\n;";
}                           

//
// static member functions
//


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.1  1997/07/03 03:33:52  mkl
// new approach: surfaces vs volumes; box tracing
//
//


