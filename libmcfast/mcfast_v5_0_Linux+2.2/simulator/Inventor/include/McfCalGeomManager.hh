#include "projectiveCalData.hh"
#include "McFBarrelCal.hh"
#include "McFForwardCal.hh"
#include "McFBoxCal.hh"
#include "calorCommon.hh"
#include "calorBoxCommon.hh"
#include <iostream.h>
#ifndef _MCFCALGEOMMANAGER_
#define  _MCFCALGEOMMANAGER_

class McfCalGeomManager
{
   public:
     static McfCalGeomDisplay* CalGeomDisp(int type, int which);
     static McfCalGeomDisplay* getCal(int ical)
     {

         return CalGeomDisp(TypeCalorProj(ical), ical);
     }
     static McfCalGeomDisplay* CalGeom(int ical);
   private:
         static void MakeCalMap();
 	 static int fillMap;

};
#endif
