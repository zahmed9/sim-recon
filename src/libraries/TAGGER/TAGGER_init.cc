// $Id$

#include <JANA/JEventLoop.h>
using namespace jana;

#include "DTAGMHit.h"
#include "DTAGFHit.h"
#include "DTAGMGeometry.h"
#include "DTAGFGeometry.h"
#include "DTAGMGeometry_factory.h"
#include "DTAGFGeometry_factory.h"


jerror_t TAGGER_init(JEventLoop *loop)
{
  /// Create and register TAGGER data factories
  loop->AddFactory(new JFactory<DTAGMHit>());
  loop->AddFactory(new JFactory<DTAGFHit>());
  loop->AddFactory(new JFactory<DTAGMHit>("TRUTH"));
  loop->AddFactory(new JFactory<DTAGFHit>("TRUTH"));
  loop->AddFactory(new DTAGMGeometry_factory());
  loop->AddFactory(new DTAGFGeometry_factory());
  
  return NOERROR;
}
