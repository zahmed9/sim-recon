// $Id$

#include <JANA/JEventLoop.h>
using namespace jana;

#include "DTAGMHit.h"
#include "DTAGFHit.h"
#include "DTAGMGeometry.h"
#include "DTAGFGeometry.h"

typedef JFactory<DTAGMHit> DTAGMHit_factory;
typedef JFactory<DTAGFHit> DTAGFHit_factory;
typedef JFactory<DTAGMGeometry> DTAGMGeometry_factory;
typedef JFactory<DTAGFGeometry> DTAGFGeometry_factory;


jerror_t TAGGER_init(JEventLoop *loop)
{
  /// Create and register TAGGER data factories
  loop->AddFactory(new DTAGMHit_factory());
  loop->AddFactory(new DTAGFHit_factory());
  loop->AddFactory(new DTAGMGeometry_factory());
  loop->AddFactory(new DTAGFGeometry_factory());
  
  return NOERROR;
}
