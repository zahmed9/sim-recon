//
// File: DTAGFGeometry_factory.h
// Created: Sat Jul 5 10:09:27 EST 2014
// Creator: jonesrt on gluey.phys.uconn.edu
//

#ifndef _DTAGFGeometry_factory_
#define _DTAGFGeometry_factory_

#include "JANA/JFactory.h"
#include "DTAGFGeometry.h"

class DTAGFGeometry_factory : public JFactory<DTAGFGeometry> {
 public:
   DTAGFGeometry_factory() {}
   ~DTAGFGeometry_factory(){}

 private:
   jerror_t brun(JEventLoop *loop, int runnumber);   
   jerror_t erun(void);   
};

#endif // _DTAGFGeometry_factory_
