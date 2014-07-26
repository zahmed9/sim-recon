//
// File: DTAGMGeometry.cc
// Created: Sat Jul 5 10:18:56 EST 2014
// Creator: jonesrt on gluey.phys.uconn.edu
//

#include <stdlib.h>
#include <iostream>
#include <map>

#include <JANA/JApplication.h>
#include <JANA/JEvent.h>
#include "DTAGMGeometry.h"

const unsigned int DTAGMGeometry::kRowCount;
const unsigned int DTAGMGeometry::kColumnCount;
const unsigned int DTAGMGeometry::kChannelCount;
const double DTAGMGeometry::kFiberWidth;
const double DTAGMGeometry::kFiberLength;

//---------------------------------
// DTAGMGeometry    (Constructor)
//---------------------------------
DTAGMGeometry::DTAGMGeometry(JEventLoop *loop, int runnumber)
{
   /* read tagger set endpoint energy from calibdb */
   char dbname1[80];
   sprintf(dbname1, "/PHOTON_BEAM/endpoint_energy:%d:mc", runnumber);
   std::map<string,double> result1;
   loop->GetCalib(dbname1, result1);
   if (result1.find("endpoint_energy_GeV") == result1.end()) {
      std::cerr << "Error in DTAGMGeometry constructor: "
                << "failed to read photon beam endpoint energy "
                << "from calibdb!"
                << std::endl;
      m_endpoint_energy_GeV = 0;
   }
   else {
      m_endpoint_energy_GeV = result1["endpoint_energy_GeV"];
   }

   /* read microscope channel energy bounds from calibdb */
   char dbname2[80];
   sprintf(dbname2, "/PHOTON_BEAM/microscope/scaled_energy_range:%d:mc",
           runnumber);
   std::vector<std::map<string,double> > result2;
   loop->GetCalib(dbname2, result2);
   if (result2.size() != kChannelCount) {
      std::cerr << "Error in DTAGMGeometry constructor: "
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

   for (unsigned int i=0; i < kChannelCount; ++i) {
      m_row_number[i] = 0;      // default is a sum channel
      m_column_number[i] = i;   // with column == channel number
      for (unsigned int j=0; j < i; ++i) {
         if (m_scaled_energy_range[2*i] == m_scaled_energy_range[2*j] &&
             m_scaled_energy_range[2*i+1] == m_scaled_energy_range[2*j+1])
         {
            // repeated energy bins are sets of 5 individual channels
            // with row numbers 1..5
            m_row_number[i] = m_row_number[j] + 1;
            m_column_number[i] = j;
         }
      }
   }
}

DTAGMGeometry::~DTAGMGeometry() { }

bool DTAGMGeometry::row_column_to_channel(int row, int column, int &channel)
const
{
   for (channel=0; channel < (int)kChannelCount; ++channel) {
      if (row == m_row_number[channel] && column == m_column_number[channel]) {
         return true;
      }
   }
   return false;
}

bool DTAGMGeometry::channel_to_row_column(int channel, int &row, int &column)
const
{
   if (channel >= 0 && channel < (int)kChannelCount) {
      column = m_column_number[channel];
      row = m_row_number[channel];
      return true;
   }
   return false;
}

bool DTAGMGeometry::E_to_column(double E, int &column)
const
{
   double x = E/m_endpoint_energy_GeV;
   for (column=0; column < (int)kColumnCount; ++column) {
      if (x <= m_scaled_energy_range[2*column] &&
          x >= m_scaled_energy_range[2*column+1])
         return true;
   }
   return false;
}

double DTAGMGeometry::getElow(unsigned int column)
const
{
   if (column < kColumnCount)
      return m_endpoint_energy_GeV * m_scaled_energy_range[2*column+1];
   else
      return 0;
}

double DTAGMGeometry::getEhigh(unsigned int column)
const
{
   if (column < kColumnCount)
      return m_endpoint_energy_GeV * m_scaled_energy_range[2*column];
   else
      return 0;
}
