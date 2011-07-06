// $Id$
//
///    File: DTOFHit_factory.h
/// Created: Thu Jun  9 10:05:21 EDT 2005
/// Creator: davidl (on Darwin wire129.jlab.org 7.8.0 powerpc)
///
/// Addition: command line parmeter -PTOF:TOF_POINT_TAG=TRUTH will initiate
///           the use of TOFHitRaw::TRUTH information to calculate the TOFHit positions
///           (e.q. use of unsmeared data)


#ifndef _DTOFHit_factory_
#define _DTOFHit_factory_

#include "JANA/JFactory.h"
#include "JANA/JApplication.h"
#include "JANA/JParameterManager.h"
#include "JANA/JEventLoop.h"
#include "DTOFHit.h"

using namespace jana;

/// \htmlonly
/// <A href="index.html#legend">
///	<IMG src="CORE.png" width="100">
///	</A>
/// \endhtmlonly

/// 2-ended TOF coincidences. The individual hits come from DTOFRawHit objects and
/// the 2 planes are combined into single hits in the DTOFPoint objects. This is the
/// intermediate set of objects between the two.

class DTOFHit_factory:public JFactory<DTOFHit>{
 public:
  DTOFHit_factory(){TOF_POINT_TAG="";gPARMS->SetDefaultParameter("TOF:TOF_POINT_TAG", TOF_POINT_TAG,"");};
  ~DTOFHit_factory(){};
  
  string TOF_POINT_TAG;
  double C_EFFECTIVE;
  double HALFPADDLE;
  double E_THRESHOLD;
  double ATTEN_LENGTH;

 protected:
  //jerror_t init(void);					///< Called once at program start.
  jerror_t brun(JEventLoop *eventLoop, int runnumber);	        ///< Called everytime a new run number is detected.
  jerror_t evnt(JEventLoop *eventLoop, int eventnumber);	///< Called every event.
  //jerror_t erun(void);					///< Called everytime run number changes, provided brun has been called.
  //jerror_t fini(void);					///< Called after last event of last event source has been processed.
};

#endif // _DTOFHit_factory_
