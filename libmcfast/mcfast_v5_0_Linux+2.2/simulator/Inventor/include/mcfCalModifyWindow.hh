#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include "mcfWindow.hh"
#include "mcfDisplay.hh"
#include "mcfDisplayList.hh"
#include "mcfPlotWindow.hh"
#ifndef MCFCALMODIFYWINDOW
#define MCFCALMODIFYWINDOW
class mcfCalModifyWindow : public mcfWindow
{
     friend void plotCalApplyCB
                       ( Widget, XtPointer *data, XtPointer *);
     friend void plotCalOkCB
                       ( Widget, XtPointer *data, XtPointer *);
     friend void plotCalInfoModify
                       ( Widget w, XtPointer *data, XtPointer *callData);
     friend void calThresholdCB( Widget w, XtPointer *data, XtPointer *);

     private:
        mcfPlotWindow *win;
        Widget form;
        calDispInfo calInfo;
        toggleButtonCbData *cbData;
     public:
        mcfCalModifyWindow(mcfPlotWindow *window)
        {
           win = window;
           mcfDisplay *display = win->getDisplay();
           calDispInfoSet(display->getCalInfo(),&calInfo);
           makeMcfWindow( win->getShell() );

        }
        ~mcfCalModifyWindow(void);
        mcfPlotWindow *GetPlot(void)
        {
           return win;
        }
        Widget getForm(void)
        {
           return form;
        }
     protected:
        mcfCalModifyWindow(void)
        {
           win = NULL;
        };
        void makeMcfWindow(Widget main);
};
#endif
static void plotCalModifyMenuCB( Widget, XtPointer *data, XtPointer *);
static void plotCalDismissCB( Widget, XtPointer *data, XtPointer *);
