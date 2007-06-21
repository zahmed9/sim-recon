// $Id$
//
//    File: DMCTrackHit.h
// Created: Mon Apr  4 08:18:07 EDT 2005
// Creator: davidl (on Darwin wire129.jlab.org 7.8.0 powerpc)
//

#ifndef _DMCTrackHit_
#define _DMCTrackHit_

#include "JANA/JObject.h"
#include "JANA/JFactory.h"
#include "GlueX.h"

class DMCTrackHit:public JObject{
 public:
  HDCLASSDEF(DMCTrackHit);
  
  float r,phi,z;	///< coordinates of hit in cm and rad
  int track;		///< Track number
  int primary;	///< primary track=1    not primary track=0
  int ptype;    /// particle type  
  DetectorSystem_t system;///< 1=CDC 2=FDC 4=BCAL 8=TOF 16=Cherenkov 32=FCAL 64=UPV
};

#endif // _DMCTrackHit_

