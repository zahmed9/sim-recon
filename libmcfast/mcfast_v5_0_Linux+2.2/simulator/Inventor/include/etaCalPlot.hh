#include "calPlot.hh"
class etaCalPlot : public calPlot
{
public:
      etaCalPlot(void);
      SoSeparator *MakePlotFrame(int ncal, int *pical);
      SoSeparator *MakeEnergyPlot(void);
};
