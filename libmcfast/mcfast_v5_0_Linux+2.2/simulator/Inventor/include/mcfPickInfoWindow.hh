#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include "mcfWindow.hh"
#ifndef MCFPICKINFOWINDOW
#define MCFPICKINFOWINDOW

//This class is a "Singleton".  See pg 127 of "Design Patterns"

class mcfPickInfoWindow : public mcfWindow
{
     private:
        Widget form;
        Widget scrolledText;
        int popped;
        static mcfPickInfoWindow *_pickInfoWindow;   
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
        
        static mcfPickInfoWindow *pickInfoWindow(Widget parent);
        
        void updateText(const char *name);

     protected:
        mcfPickInfoWindow(void)
        {
           form = NULL;
           scrolledText = NULL;
        };
        mcfPickInfoWindow(Widget parent)
        {
           makeMcfWindow(parent);
           SetPopped(1);
        };
        void makeMcfWindow(Widget main);
 };
#endif
static void pickInfoMenuCB( Widget, XtPointer *data, XtPointer *);
static void pickInfoDismissCB( Widget, XtPointer *data, XtPointer *);
