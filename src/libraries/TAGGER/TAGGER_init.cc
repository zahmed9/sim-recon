// $Id$

#include "DEvent.h"
#include "DFactory_TAGGERHits.h"

derror_t TAGGER_init(DEvent *event)
{
	/// Create and register TAGGER data factories
	event->AddFactory(new DFactory_TAGGERHits(event));

	return NOERROR;
}
