//
// File: DTAGFGeometry.cc
// Created: Sat Jul 5 10:18:56 EST 2014
// Creator: jonesrt on gluey.phys.uconn.edu
//

#include <stdlib.h>
#include <iostream>
#include <map>

#include <JANA/JApplication.h>
#include <JANA/JEvent.h>
#include "DTAGFGeometry.h"

const unsigned int DTAGFGeometry::kChannelCount;

//---------------------------------
// DTAGFGeometry    (Constructor)
//---------------------------------
DTAGFGeometry::DTAGFGeometry(JEventLoop *loop, int runnumber)
{
   /* read tagger set endpoint energy from calibdb */
   char dbname1[80];
   sprintf(dbname1, "/PHOTON_BEAM/endpoint_energy:%d:mc", runnumber);
   std::map<string,double> result1;
   loop->GetCalib(dbname1, result1);
   if (result1.find("endpoint_energy_GeV") == result1.end()) {
      std::cerr << "Error in DTAGFGeometry constructor: "
                << "failed to read photon beam endpoint energy "
                << "from calibdb!"
                << std::endl;
      m_endpoint_energy_GeV = 0;
   }
   else {
      m_endpoint_energy_GeV = result1["endpoint_energy_GeV"];
   }

   /* read fixed array channel energy bounds from calibdb */
   char dbname2[80];
   sprintf(dbname2, "/PHOTON_BEAM/fixed_array/scaled_energy_range:%d:mc",
           runnumber);
   std::vector<std::map<string,double> > result2;
   loop->GetCalib(dbname2, result2);
   if (result2.size() != kChannelCount) {
      jerr << "Error in DTAGFGeometry constructor: "
           << "failed to read photon beam scaled_energy_range table"
           << "from calibdb!"
           << std::endl;
      for (unsigned int i=0; i < kChannelCount; ++i) {
         m_scaled_energy_range[2*i] = 0;
         m_scaled_energy_range[2*i+1] = 0;
      }
   }
   else {
      for (unsigned int i=0; i < kChannelCount; ++i) {
         m_scaled_energy_range[2*i] = (result2[i])["Xlow"];
         m_scaled_energy_range[2*i+1] = (result2[i])["Xhigh"];
      }
   }
}

DTAGFGeometry::~DTAGFGeometry() { }

bool DTAGFGeometry::E_to_channel(double E, int &channel) const
{
   double x = E/m_endpoint_energy_GeV;
   for (channel=0; channel < (int)kChannelCount; ++channel) {
      if (x <= m_scaled_energy_range[2*channel] &&
          x >= m_scaled_energy_range[2*channel+1])
         return true;
   }
   return false;
}

double DTAGFGeometry::getElow(unsigned int channel) const
{
   if (channel < kChannelCount)
      return m_endpoint_energy_GeV * m_scaled_energy_range[2*channel+1];
   else
      return 0;
}

double DTAGFGeometry::getEhigh(unsigned int channel) const
{
   if (channel < kChannelCount)
      return m_endpoint_energy_GeV * m_scaled_energy_range[2*channel];
   else
      return 0;
}
