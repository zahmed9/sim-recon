#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include "mcfWindow.hh"
#include "mcfDisplay.hh"
#include "mcfDisplayList.hh"
#include "mcfPlotWindow.hh"
#ifndef MCFTRACEMODIFYWINDOW
#define MCFTRACRMODIFYWINDOW
class mcfTraceModifyWindow : public mcfWindow
{
     friend void plotTraceApplyCB
                       ( Widget, XtPointer *data, XtPointer *);
     friend void plotTraceOkCB
                       ( Widget, XtPointer *data, XtPointer *);
     friend void plotTraceInfoModify
                       ( Widget w, XtPointer *data, XtPointer *callData);
     friend void maxTextCB( Widget w, XtPointer *data, XtPointer *);

     friend void plotTraceScaleModify( Widget, XtPointer *data, XtPointer *);
     private:
        mcfPlotWindow *win;
        Widget form;
        Widget EtaMinScale;
        Widget EtaMaxScale;
        Widget ptScale;
        traceDispInfo traceInfo;
        toggleButtonCbData *cbData;
     public:
        mcfTraceModifyWindow(mcfPlotWindow *window)
        {
           win = window;
           mcfDisplay *display = win->getDisplay();
           traceDispInfoSet(display->getTraceInfo(),&traceInfo);
           makeMcfWindow( win->getShell() );

        }
        ~mcfTraceModifyWindow(void);
        void mcfTraceModifyWindow::getScales(void);
        mcfPlotWindow *GetPlot(void)
        {
           return win;
        }
        Widget getForm(void)
        {
           return form;
        }
     protected:
        mcfTraceModifyWindow(void)
        {
           win = NULL;
        };
        void makeMcfWindow(Widget main);
};
#endif
static void plotTraceModifyMenuCB( Widget, XtPointer *data, XtPointer *);
static void plotTraceDismissCB( Widget, XtPointer *data, XtPointer *);
