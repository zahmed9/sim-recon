#include <X11/StringDefs.h>
#include <X11/Intrinsic.h>
#include <X11/Xatom.h>

#include <Xm/Xm.h>
#include <Xm/RowColumn.h>
#include <Xm/BulletinB.h>
#include <Xm/CascadeB.h>
#include <Xm/CascadeBG.h>
#include <Xm/FileSB.h>
#include <Xm/Form.h>
#include <Xm/Label.h>
#include <Xm/FileSB.h>
#include <Xm/PushB.h>
#include <Xm/PushBG.h>
#include <Xm/SeparatoG.h>
#include <Xm/Text.h>
#include <Xm/ToggleB.h>
#include <Xm/ToggleBG.h>

#include "displayTypes.hh"

#ifndef MCFPLOTDEFINE
#define MCFPLOTDEFINE
//Set up information for call backs
struct plotDefineCbData
{
   class mcfPlotDefine *plotDefine;
   PlotTypes type;
};


class mcfPlotDefine
{
   friend void plotDefineCB(Widget, XtPointer *data, XtPointer);
   friend void calHitsCB(Widget, XtPointer *data, 
        	  XmToggleButtonCallbackStruct *call_data);
   friend void tracesCB(Widget, XtPointer *data, 
        	  XmToggleButtonCallbackStruct *call_data);
   friend void trackHitsCB(Widget, XtPointer *data, 
                     XmToggleButtonCallbackStruct *call_data);
   friend void detectorCB(Widget, XtPointer *data, 
                            XmToggleButtonCallbackStruct *call_data);
   friend void vertexCB(Widget, XtPointer *data, 
        	  XmToggleButtonCallbackStruct *call_data);

   friend void ivDefineCB(Widget, XtPointer *data, 
                           XmToggleButtonCallbackStruct *call_data);
   private:
        
   public:
        displayType calHits;
        displayType traces;
        displayType trackHits;
        displayType detector;
        displayType vertex;
        displayType ivFile;
        mcfPlotDefine(void)
        {
           plotTypeInitialize(&calHits);
           plotTypeInitialize(&traces);
           plotTypeInitialize(&trackHits);
           plotTypeInitialize(&detector);
           plotTypeInitialize(&vertex);
           plotTypeInitialize(&ivFile);
        }
        void displayPlotDefinitionDialog(Widget parent);
        PlotTypes getPlotType(XtPointer *data, 
                              XmToggleButtonCallbackStruct *call_data);


};
#endif
