// -*- C++ -*-
//
// Package:     Tracing
// Module:      Surface
// 
// Description: <one line class summary>
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Wed June 25 15:21:36 EDT 1997

// system include files
#include <iostream.h>
#include <float.h>

// user include files
#include "Surface.hh"
#include "MCParticle.hh"
#include "UserSettings.hh"

#include "report.hh"

#include "externFortran.hh"
#include "wtrack_struct.hh"
#include "bfield_struct.hh"

// STL classes

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
Surface::Surface()
{
}

Surface::Surface( const Surface& surface )
{
   *this = surface;
}

Surface::~Surface()
{
}

//
// assignment operators
//
const Surface& Surface::operator=( const Surface& surface ) 
{
   if( this != &surface ) 
   {
      Traceable::operator=( surface );
   }

   return *this;
}


//
// member functions
//
//
// const member functions
//

// fix for fortran routines
int 
Surface::type() const
{
   return 0;
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
// Revision 1.3  1998/05/15 03:50:57  mkl
// first attempt at taking one step to new wtrack without using move_wtk_arc routine
//
// Revision 1.2  1997/11/11  01:17:41  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.1  1997/07/03  03:33:53  mkl
// new approach: surfaces vs volumes; box tracing
//
//               
