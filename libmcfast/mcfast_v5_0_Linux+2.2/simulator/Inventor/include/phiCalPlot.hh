#include "calPlot.hh"
#ifndef PHICALPLOT
#define PHICALPLOT
class phiCalPlot : public calPlot
{
public:
      phiCalPlot(void)
      {
	  eventInformation *eventInfo = eventInformation::eventInfo();
	  energy = eventInfo->calPhiEnergy();
      }
      SoSeparator *MakePlotFrame(int ncal, int *pical);
};
#endif
