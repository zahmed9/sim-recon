#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include "mcfWindow.hh"
#ifndef MCFENERGYSCALEWINDOW
#define MCFENERGYSCALEWINDOW
const float DEFAULTSCALE = 20.0;
//This class is a "Singleton".  See pg 127 of "Design Patterns"

class mcfEnergyScaleWindow : public mcfWindow
{
        friend void 
             energyScaleMenuCB( Widget, XtPointer *data, XtPointer *);
       friend void newScaleValueCB(Widget, XtPointer *data, XtPointer *call);
        friend void noScaleValueCB(Widget, XtPointer *data, XtPointer *call);
     private:
        Widget form;
        Widget prompt;
        float maxScale;
        int popped;
        static mcfEnergyScaleWindow *_energyScaleWindow;   
     public:
        int GetPopped(void)
        {
           return popped;
        }
         void SetPopped(int state)
        {
           popped = state;
        }
        Widget getForm(void)
        {
           return form;
        }
        float GetScaleMax(void)
        {
           return maxScale;
        }
        static mcfEnergyScaleWindow *energyScaleWindow(Widget parent);
        
        void updateMax( float max );
        SoSeparator *makeScale(void);
     protected:
        mcfEnergyScaleWindow(void)
        {
           form = NULL;
           maxScale = DEFAULTSCALE;
           prompt = NULL;
        };
        mcfEnergyScaleWindow(Widget parent)
        {
           maxScale = DEFAULTSCALE;
           prompt = NULL;
           makeMcfWindow(parent);
           SetPopped(1);
        };
        void makeMcfWindow(Widget main);
 };
#endif

