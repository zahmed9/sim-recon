// -*- C++ -*-
//
// Package:     Tracing
// Module:      Direction
// 
// Description: 3-DIM space Direction
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     June 25, 1997

// system include files

// user include files
#include "Direction.hh"
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
Direction::Direction( const DFLOAT cosx, const DFLOAT cosy, const DFLOAT cosz )
   : Vector( cosx, cosy, cosz )
{
}

Direction::Direction( const WTrackStruct& wtrack )
   : Vector( wtrack.px/wtrack.p, wtrack.py/wtrack.p, wtrack.pz/wtrack.p )
{
}

//Direction::Direction( const Direction& )
//{
//}

Direction::~Direction()
{
}

//
// assignment operators
//
//const Direction& Direction::operator=( const Direction& volume )
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
Direction::printOn( ostream& str ) const
{
   str << "\nDirection( " 
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
// Revision 1.1  1997/07/03 03:33:47  mkl
// new approach: surfaces vs volumes; box tracing
//
//


