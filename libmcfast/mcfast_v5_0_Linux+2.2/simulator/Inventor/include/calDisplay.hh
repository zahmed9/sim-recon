#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoDrawStyle.h>
#include <Inventor/nodes/SoMaterial.h>
#include "displayTypes.hh"
#include "calPlot.hh"
#include "calPlotManager.hh"
#ifndef CALDISPLAY
#define CALDISPLAY
class calDisplay
{
private:
      calPlot *calorPlot;
      SoSeparator *calEnergy;
      int Action;
      static int ncal;
      static int *pical;
      static float *threshold;
public:
       calDisplay(void)
       {
         calorPlot = NULL;
         calEnergy = NULL;
         Action = 0;
       }
       ~calDisplay(void)
       {
          if ( calorPlot != NULL ) delete calorPlot;
       }
       void makeCalPlot(SoSeparator *root, PlotTypes calEtype, 
       calDispInfo Info);
       void updateCalPlot(SoSeparator *root, PlotActions Action,
       calDispInfo Info);
       void updateCalEnergy(SoSeparator *hits, calDispInfo Info);
       SoSeparator *makeCalEnergy(calDispInfo Info);
       SoSeparator *makeCalGeometry(int ncal, int *pical);
       SoSeparator *FindCalEnergy(void);
};
#endif
