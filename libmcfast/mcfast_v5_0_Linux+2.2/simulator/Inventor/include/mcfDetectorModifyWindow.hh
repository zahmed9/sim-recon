#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include "mcfWindow.hh"
#include "mcfDisplay.hh"
#include "mcfDisplayList.hh"
#include "mcfPlotWindow.hh"
#ifndef MCFDETECTORMODIFYWINDOW
#define MCFDETECTORMODIFYWINDOW
class mcfDetectorModifyWindow : public mcfWindow
{
     private:
        mcfPlotWindow *win;
        Widget form;
        static Widget scrollTree;  //scrolled window to hold tree
        static Widget treeWidget;  //the tree widget
        toggleButtonCbData *cbData;
        
        static void ColorEditorCB( Widget, XtPointer*, XtPointer *);
     public:
        mcfDetectorModifyWindow(mcfPlotWindow *window)
        {
           win = window;
           mcfDisplay *display = win->getDisplay();
           makeMcfWindow( win->getShell() );
           treeWidget = NULL;

        }
        ~mcfDetectorModifyWindow(void);
        Widget getTreeWidget(void)
        {
           return treeWidget;
        }
        mcfPlotWindow *GetPlot(void)
        {
           return win;
        }
        Widget getForm(void)
        {
           return form;
        }
       static void remakeTree(void); 
     protected:
        mcfDetectorModifyWindow(void)
        {
           win = NULL;
        };
        void makeMcfWindow(Widget main);
};
#endif
static void plotDetModifyMenuCB( Widget, XtPointer *data, XtPointer *);
static void plotDetDismissCB( Widget, XtPointer *data, XtPointer *);
static void plotDetOkCB( Widget, XtPointer *data, XtPointer *);
static void plotDetApplyCB( Widget, XtPointer *data, XtPointer *);
