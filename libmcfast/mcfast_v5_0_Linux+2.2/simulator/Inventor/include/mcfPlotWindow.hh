#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include "mcfWindow.hh"
#include "mcfDisplay.hh"
#ifndef MCFPLOTWINDOW
#define MCFPLOTWINDOW
class mcfPlotDefine;
class mcfPlotWindow : public mcfWindow
{
     private:
        mcfDisplay *display;  //the orginating display
        SoXtViewer *viewer;
        static int nPlots;
        char windowName[100];
     public:
        mcfPlotWindow(Widget main)
        {
           nPlots++;
           display = new mcfDisplay();
           makeMcfWindow( main );
           display->makeMcfDisplay(viewer);
        }
        mcfPlotWindow(Widget main, mcfPlotDefine &plot)
        {
           nPlots++;
           display = new mcfDisplay(plot);
           makeMcfWindow( main );
           display->makeMcfDisplay(viewer);
        }
        mcfDisplay *getDisplay(void)
        {
           return display;
        }
        Widget getShell(void)
        {
           return Shell;
        }
        void setWindowName(char *name)
        {
            strcpy(windowName, name);
            changeTitle(Shell ,windowName);
        }
        char *getWindowName(void)
        {
            return windowName;
        }
        Boolean checkWindowName(char *name)
        {
        
           if(strcmp(windowName, name) == 0)return TRUE;
           return FALSE; 
        }
        ~mcfPlotWindow(void);
        SoXtViewer  *mcfPlotGetViewer(void)
        {
            return viewer;
        }
        void updatePlotWindowTrace(traceDispInfo tinfo)
        {
            display->updateMcfTraceDisplay(tinfo);

        }
        void updatePlotWindowHits(hitsDispInfo hinfo)
        {
            display->updateMcfHitsDisplay(hinfo);
        }
        void updatePlotWindowCalHits(calDispInfo cinfo)
        {
            display->updateMcfCalHitDisplay(cinfo);

        }
        void updatePlotWindowCalHits(void)
        {
            display->updateMcfCalHitDisplay();

        }
        void updatePlot(displayType cdisp, displayType tdisp, displayType hdisp)
        {
             display->changeCalDisplay(cdisp);
             display->changeTraceDisplay(tdisp);
             display->changeHitsDisplay(hdisp);
             display->updateMcfDisplay();

        }
        static void makeWindowNameText(mcfPlotWindow *window);
        static void dismissNameWindowCB(Widget, XtPointer *data, XtPointer *);
        static void setWindowNameCB(Widget w, XtPointer *data, XtPointer *);
     protected:
        mcfPlotWindow(void)
        {
           Shell = NULL;
           display = NULL;
        };
        void makeMcfWindow(Widget main);
        void defineMenuAndButtons(void);
};
#endif
static void plotWindowCB( Widget, XtPointer *data, XtPointer *);
