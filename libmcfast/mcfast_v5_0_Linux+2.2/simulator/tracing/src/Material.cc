// -*- C++ -*-
//
// Package:     <package>
// Module:      Material
// 
// Description: Base class for all Materials; just a space holder!
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files
#include <math.h>
#include <assert.h>

// user include files
#include "report.hh"

#include "Material.hh"

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
Material::Material()
{
}

Material::~Material()
{
}

//
// assignment operators
//
// const Material& Material::operator=( const Material& )
// {
// }

//
// member functions
//
//
// const member functions
//

// I/O
void
Material::printOn( ostream& str ) const
{
   str << "\nMaterial of type( " << nameOf() << " )\n";
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
// Revision 1.10  1997/08/02 02:59:38  mkl
// RealMaterial and AssociatedMaterial derive from placeholder Material
//
// Revision 1.9  1997/08/01  20:56:31  mkl
// forward declare stl containers
//
// Revision 1.8  1997/07/03  03:33:50  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.7  1997/05/10  01:41:38  mkl
// minor adjustments as part of the bug hunt
//
// Revision 1.6  1997/04/23  14:42:45  bphyslib
// assert instead of fancy error messages
//
// Revision 1.5  1997/04/23  02:42:41  bphyslib
// debugged Bremsstrahlung
//
// Revision 1.4  1997/04/23  01:56:18  bphyslib
// debugged photon conversions
//
// Revision 1.3  1997/04/23  01:48:17  bphyslib
// debugged photon conversions
//
// Revision 1.2  1997/04/19  11:39:39  mkl
// fixes suggested by Julia: change from layerIndex to deviceIndex in
// DetCalorimeter.cc; reversal of if logic in Material::doPhotonConversion().
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


