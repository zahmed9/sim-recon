//
// File: DTAGFGeometry_factory.cc
// Created: Sat Jul 5 10:09:27 EST 2014
// Creator: jonesrt on gluey.phys.uconn.edu
//

#include "DTAGFGeometry_factory.h"
#include "DTAGFGeometry.h"

//------------------
// brun
//------------------
jerror_t DTAGFGeometry_factory::brun(JEventLoop *loop, int runnumber)
{
   assert( _data.size() == 0 );

   flags = PERSISTANT;
   _data.push_back( new DTAGFGeometry(loop, runnumber) );
   
   return NOERROR;
}

//------------------
// erun
//------------------
jerror_t DTAGFGeometry_factory::erun(void)
{
   for (unsigned int i=0; i < _data.size(); i++)
      delete _data[i];
   _data.clear();
   
   return NOERROR;
}
