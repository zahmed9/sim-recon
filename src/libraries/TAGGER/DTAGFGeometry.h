//
// File: DTAGFGeometry.h
// Created: Sat Jul 5, 10:09:27 EST 2014
// Creator: jonesrt on gluey.phys.uconn.edu
//

#ifndef _DTAGFGeometry_
#define _DTAGFGeometry_

#include <JANA/JFactory.h>
#include <JANA/JObject.h>
using namespace jana;

#include "units.h"

class DTAGFGeometry : public JObject {
 public:
   
   JOBJECT_PUBLIC(DTAGFGeometry);

   DTAGFGeometry(JEventLoop *loop, int runnumber);
   ~DTAGFGeometry();

   static const unsigned int kChannelCount = 220;

   bool E_to_channel(double E, int &channel) const;

   double getElow(unsigned int channel) const;
   double getEhigh(unsigned int channel) const;

   void toStrings(vector<pair<string,string> > &items) const {
      AddString(items, "kChannelCount", "%d", kChannelCount);
   }
   
 private:
   double m_endpoint_energy_GeV;
   double m_scaled_energy_range[2*kChannelCount];
};

#endif // _DTAGFGeometry_

