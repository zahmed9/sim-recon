// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      WorldFactory
// 
// Description: <one line class summary>
//
// Implementation:
//     <Notes on implementation>
//
// Author:      Martin Lohner
// Created:     Mon Oct 20 10:40:43 EDT 1997
// $Id$
//
// Revision history
//
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.1  1997/11/11 01:17:45  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//

//#include "Experiment/Experiment.h"

// system include files
#if defined(STL_TEMPLATE_DEFAULT_PARAMS_FIRST_BUG)
#endif /* STL_TEMPLATE_DEFAULT_PARAMS_FIRST_BUG */

// user include files
//#include "Experiment/report.h"
#include "WorldFactory.hh"
#include "CompositeMedium.hh"

// STL classes

//
// constants, enums and typedefs
//

static const char* const kFacilityString = "Tracing.WorldFactory" ;

//
// static data member definitions
//
CompositeMedium* WorldFactory::s_worldInstance = 0;

//
// constructors and destructor
//
//WorldFactory::WorldFactory()
//{
//}

// WorldFactory::WorldFactory( const WorldFactory& )
// {
// }

//WorldFactory::~WorldFactory()
//{
//}

//
// assignment operators
//
// const WorldFactory& WorldFactory::operator=( const WorldFactory& )
// {
// }

//
// member functions
//

//
// const member functions
//

//
// static member functions
//
CompositeMedium*
WorldFactory::createWorld()
{
   if( s_worldInstance == 0 ) {
      s_worldInstance = new CompositeMedium;
   }

   return s_worldInstance;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.1  1997/11/11 01:17:45  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
//
//

