//
// File: DTAGMGeometry.h
// Created: Sat Jul 5, 10:09:27 EST 2014
// Creator: jonesrt on gluey.phys.uconn.edu
//

#ifndef _DTAGMGeometry_
#define _DTAGMGeometry_

#include <JANA/JFactory.h>
#include <JANA/JObject.h>
using namespace jana;

#include "units.h"

class DTAGMGeometry : public JObject {
 public:
   
   JOBJECT_PUBLIC(DTAGMGeometry);

   DTAGMGeometry(JEventLoop *loop, int runnumber);
   ~DTAGMGeometry();

   static const unsigned int kRowCount = 5;
   static const unsigned int kColumnCount = 100;
   static const unsigned int kChannelCount = 120;
   static const double kFiberWidth = 0.2; // cm
   static const double kFiberLength = 2.0; // cm

   bool row_column_to_channel(int row, int column, int &channel) const;
   bool channel_to_row_column(int channel, int &row, int &column) const;
   bool E_to_column(double E, int &column) const;

   double getElow(unsigned int column) const;
   double getEhigh(unsigned int column) const;

   void toStrings(vector<pair<string,string> > &items) const {
      AddString(items, "kFiberWidth", "%f cm", kFiberWidth);
      AddString(items, "kFiberLength", "%f cm", kFiberLength);
      AddString(items, "kRowCount", "%d", kRowCount);
      AddString(items, "kColumnCount", "%d", kColumnCount);
      AddString(items, "kChannelCount", "%d", kChannelCount);
   }
   
 private:
   double m_endpoint_energy_GeV;
   double m_scaled_energy_range[2*kChannelCount];

   // column numbers lie within range 0..kColumnCount-1
   // row number is 0 for column sum, 1..kRowCount for individual fibers
   int    m_column_number[kChannelCount];
   int    m_row_number[kChannelCount];
};

#endif // _DTAGMGeometry_
