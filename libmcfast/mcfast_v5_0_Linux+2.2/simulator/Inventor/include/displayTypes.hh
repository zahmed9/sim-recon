//This is the structure that defines the allowed types of plots.  It may be
//a bad idea to have all the plot types with a single enum
#include <X11/StringDefs.h>
#include <X11/Intrinsic.h>

#ifndef DISPLAYTYPES
#define DISPLAYTYPES

enum toggleType {OFF, ON};

enum momType {MOMENTUM,TRANSMOM};

enum PlotCatagory {CALHIT = 0, TRACEDISP, DETECTOR, EXTERNAL, HITS, 
                   PLOT_CATAGORY_ALL}; 
static char CatagoryNames[][25] =
{
   "Calorimeter hits",
   "Trace Information",
   "Detector Information",
   "Geometry Information",
   "Hit Information"
};

enum PlotTypes {TDPLOT=0, ETAPLOT, PHIPLOT, LEGOPLOT, RZPLOT, RPHIPLOT,
                MOMPLOT, NOPLOT, IVFILE, SAMEPLOT};
enum PlotActions { NEXTEVENT, NEWPARAMETERS, NOACTION, REMOVEFRAME, ADDFRAME};

const int numCalType = 5;
const int numTraceType = 5;
const int numDetectorType = 2;
const int numGeometryType = 2;
const int numHitsType = 2;
static int nValidPlots[PLOT_CATAGORY_ALL+1] =
{
   5, // number of calorimeter plots
   5, // number of trace plots
   2, // number of detector plots
   2, // number of geometry plots
   2, // number of hits plots
   14 // total number of plots
};

static PlotTypes validPlots[PLOT_CATAGORY_ALL][5] =
{
   TDPLOT,  //calorimeter plots
   ETAPLOT,
   PHIPLOT,
   LEGOPLOT,
   NOPLOT,
   
   TDPLOT,  //trace plots
   RZPLOT,
   RPHIPLOT,
   MOMPLOT,
   NOPLOT,
   
   TDPLOT,   //detector plots
   NOPLOT,
   NOPLOT,
   NOPLOT,
   NOPLOT,

   IVFILE,   //geometry plots
   NOPLOT,
   NOPLOT,
   NOPLOT,
   NOPLOT,

   TDPLOT,   //hits plots
   NOPLOT,
   NOPLOT,
   NOPLOT,
   NOPLOT
};
static toggleType plotDefaultSetting[PLOT_CATAGORY_ALL][5] =
{
   OFF,  //calorimeter plots
   OFF,
   OFF,
   OFF,
   ON,
   
   OFF,  //trace plots
   OFF,
   OFF,
   OFF,
   ON,
   
   OFF,   //detector plots
   ON,
   OFF,
   OFF,
   OFF,

   OFF,   //geometry plots
   ON,
   OFF,
   OFF,
   OFF,

   OFF,   //hit plots
   ON,
   OFF,
   OFF,
   OFF
   
};

static char PlotNames[][14] = 
{
   "3D plot",
   "Eta View",
   "Phi View",
   "Lego Plot",
   "R-Z Plot ",
   "R-Phi Plot",
   "Momentum Plot",
   "Not Displayed",
   "Geometry File",
   " "       
};
static Boolean PlotImplemented[] =
{
   True,
   True,
   True,
   False,
   True,
   True,
   False,
   True,
   True,
   True
};
struct displayType
{
        PlotTypes type;
        PlotActions action;
};
void plotTypeInitialize(displayType *temp);
void plotTypeSet(displayType set, displayType *temp);

#endif
