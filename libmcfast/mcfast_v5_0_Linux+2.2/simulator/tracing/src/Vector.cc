// -*- C++ -*-
//
// Package:     Tracing
// Module:      Vector
// 
// Description: 3-DIM Vector
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     June 25, 1997

// system include files

// user include files
#include "Vector.hh"

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
Vector::Vector( DFLOAT x, DFLOAT y, DFLOAT z )
   : m_x( x ), m_y( y ), m_z( z )
{
}

//Vector::Vector( const Vector& )
//{
//}

Vector::~Vector()
{
}

//
// assignment operators
//
//const Vector& Vector::operator=( const Vector& volume )
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
Vector::printOn( ostream& str ) const
{
   str << "\nVector( " << x() << ", " << y() << ", " << z() << " )\n;";
}                           

//
// static member functions
//


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.1  1997/07/03 03:33:55  mkl
// new approach: surfaces vs volumes; box tracing
//
//


