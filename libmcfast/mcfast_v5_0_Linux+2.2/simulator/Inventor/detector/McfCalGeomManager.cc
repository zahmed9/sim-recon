#include "McfCalGeomManager.hh"
#include "McfCalGeomMap.hh"
#include "McFRPhiCal.hh"
#include <iostream.h>
//map<int, McfCalGeomDisplay *> McfCalGeomMap::calMap;
McfCalGeomDisplay *McfCalGeomMap::calMap[40];
int McfCalGeomManager::fillMap=0;
McfCalGeomDisplay* McfCalGeomManager::CalGeomDisp(int type, int which)
{
         if(type == BARREL)
	 { 
	    cout << "Making Barrel calorimeter" << endl;
	    McFBarrelCal *bar = new McFBarrelCal;
            projectiveCalData data;
            getProjectiveCalData(which, data);
	    bar->setCalData(data);
	    return (McfCalGeomDisplay *) bar;
	 }
         else if(type == FORWARD) 
	 {
	    cout << "Making forward calorimeter" << endl;
	    McFForwardCal *forw = new McFForwardCal;
            projectiveCalData data;
            getProjectiveCalData(which, data);
	    forw->setCalData(data);
	    return (McfCalGeomDisplay *) forw;
	 }
        else if(type == RPHI) 
	 {
	    cout << "Making RPHI calorimeter" << endl;
	    McFRPhiCal *rphi = new McFRPhiCal;
            projectiveCalData data;
            getProjectiveCalData(which, data);
	    rphi->setCalData(data);
	    return (McfCalGeomDisplay *) rphi;
	 }
	 else if(type == BOX)
	 {
	    cout << "Making BOX calorimeter" << endl;
	     McFBoxCal *box = new McFBoxCal;
	     boxCalData data;
             getCalorBoxData(which, data);
	     box->setCalData(data);
             return (McfCalGeomDisplay *) box;
	 }
	 else return 0;
}
void McfCalGeomManager::MakeCalMap()
     {
        int ical, ncal;
	ncal = 1;
        for (ical = 1; ical < NumCalorProj()+1; ical++)
	{
	   cout << "making calorimeter " << ical << "of type" 
	   << TypeCalorProj(ical) << endl;
	   McfCalGeomMap::calMap[ncal] = CalGeomDisp(TypeCalorProj(ical), ical);
	   ncal++;
	}
	for (ical = 1; ical < NumCalorBox()+1; ical++)
	{
	    McfCalGeomMap::calMap[ncal] = CalGeomDisp(BOX, ical);
	    ncal++;
	}
     }
McfCalGeomDisplay* McfCalGeomManager::CalGeom(int ical)
{
   if(fillMap == 0)
   {
      fillMap = 1;
      McfCalGeomManager::MakeCalMap();
   }
   return McfCalGeomMap::calMap[ical];
}
