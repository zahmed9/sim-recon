#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include <Inventor/Xt/viewers/SoXtExaminerViewer.h>
#include <Xm/TextF.h>
#include "mcfFile.hh"
#include "mcfMainPanel.hh"
#include "mcfDisplayList.hh"
#include "mcfTraceModifyWindow.hh"
#include "mcfCalModifyWindow.hh"
#include "mcfDetectorModifyWindow.hh"
#include "ivButton.hh"
#include "mcfPlotWindow.hh"
#include "mcfPlotModify.hh"
#include "displayTypes.hh"
#include "eventInformation.hh"
#include "resetPickParameters.hh"
static Bool GLPRINIT = TRUE;
extern "C" {
#include "DialogF.h"
}

int mcfPlotWindow::nPlots = 0;
enum plotWindowEntries {
    PW_FILE = 0,
    PW_FILE_SAVE_IV,
    PW_FILE_SAVE_PS,
//    PW_FILE_NEXT_EVENT,
    PW_FILE_CLOSE,
    PW_FILE_QUIT,

    PW_PLOT,
    PW_PLOT_MODIFY_TRACE,
    PW_PLOT_MODIFY_CAL,
    PW_PLOT_MODIFY_DETECTOR,
    
    PW_CHANGE_VIEWER,
    PW_RENAME_WINDOW,
    PW_WHITE_BACKGROUND,
    PW_BLACK_BACKGROUND,
    PW_SCREEN_DOOR,
    PW_DELAYED_BLEND,
    PW_SORTED_OBJECT_BLEND,
    PW_NO_ANTIALIASING,
    PW_ANTIALIASING,
    

    PW_HELP,
    PW_HELP_FILE,
    PW_HELP_PLOT,
    PW_HELP_VIEWER,

    PW_MENU_NUM		// this must be the last entry
};
mcfPlotWindow::~mcfPlotWindow(void)
{
   XtDestroyWidget(Shell);
   mcfMainPanel::RemovePlotFromList(windowName);
   delete display;
   nPlots--;

}
void mcfPlotWindow::makeMcfWindow(Widget main)
{

// define the buttons and the pulldowns
static ivButton buttonData[] = {
   {"Save as Inventor...", PW_FILE_SAVE_IV, IV_PUSH_BUTTON,"Alt <Key> i",
   "Alt+i"},
   {"Save as Postscript...",  PW_FILE_SAVE_PS,  IV_PUSH_BUTTON, "Alt <Key> s",
   "Alt+s" },
//   {"Get Next Event...",  PW_FILE_NEXT_EVENT,  IV_PUSH_BUTTON, "Alt <Key> n", "Alt+n" },
   {"Close Plot...",     PW_FILE_CLOSE,  IV_PUSH_BUTTON, "Alt <Key> c", "Alt+c"},
   {"Quit McfIV",     PW_FILE_QUIT,  IV_PUSH_BUTTON, " ", " "},
   {"Modify Traces Display", PW_PLOT_MODIFY_TRACE, IV_PUSH_BUTTON,"", ""},
   {"Modify Calorimeter Hits..", PW_PLOT_MODIFY_CAL, IV_PUSH_BUTTON,"", ""},
   {"Modify Detector Display...", PW_PLOT_MODIFY_DETECTOR, IV_PUSH_BUTTON,"",""},
   {"Name Window", PW_RENAME_WINDOW, IV_PUSH_BUTTON,"",""},
   {"White Background", PW_WHITE_BACKGROUND, IV_PUSH_BUTTON,"",""},
   {"Black Background", PW_BLACK_BACKGROUND, IV_PUSH_BUTTON,"",""},
   {"Default Transparency", PW_SCREEN_DOOR, IV_PUSH_BUTTON,"",""},
   {"Better Transparency", PW_DELAYED_BLEND, IV_PUSH_BUTTON,"",""},
   {"Best Transparency", PW_SORTED_OBJECT_BLEND, IV_PUSH_BUTTON,"",""},
   {"No AntiAliasing", PW_NO_ANTIALIASING, IV_PUSH_BUTTON,"",""},
   {"AntiAliasing", PW_ANTIALIASING, IV_PUSH_BUTTON,"",""},
   {"File", PW_HELP_FILE,  IV_PUSH_BUTTON, "", ""},
   {"Plot", PW_HELP_PLOT,  IV_PUSH_BUTTON, "", ""},
   {"Viewer", PW_HELP_VIEWER,  IV_PUSH_BUTTON, "", ""}
};
static ivMenu pulldownData[] = {
// {name, id, subMenu, subItemCount}
   {"File",  PW_FILE, buttonData, 4 },
   {"Plot",  PW_PLOT, buttonData + 4, 3 },
   {"Modify Viewer", PW_CHANGE_VIEWER, buttonData + 7, 8},
   {"Help",  PW_HELP, buttonData + 15, 3 }
};
// Now do the work
     sprintf(windowName, "McFIV Plot Window %d", nPlots);
     Shell = MakeDetachedShell( main, windowName );
     mcfMainPanel::AddPlotToList(windowName);
     Widget form = MakeForm(Shell, 520, 520);
     Widget menuWidget = buildAndLayoutMenu(form, pulldownData,
                                                  XtNumber( pulldownData ),
                                                  (XtCallbackProc) plotWindowCB);  
     viewer  = buildAndLayoutViewer( form, menuWidget );
     if(!GLPRINIT) 
     {
       GLPRINIT = True;
// don't use GLP stuff for now
//       glpInit();
     }
     XtManageChild(form);
     XtRealizeWidget(Shell); 
      
   
     
};
void mcfPlotWindow::makeWindowNameText(mcfPlotWindow *window)
{
    int n = 0;
    Arg args[15];
    Widget Form = XmCreateFormDialog(window->Shell,"WindowName", NULL, 0);

    Widget dismiss = window->MakeDialogButton(Form, "Dismiss", 
    (XtCallbackProc) mcfPlotWindow::dismissNameWindowCB,
    (XtPointer *) Form, Form, 10);  
   
    n=0;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   5); n++;
    XtSetArg(args[n], XmNrightAttachment, XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNrightOffset,   5); n++;
    XtSetArg(args[n], XmNtopAttachment, XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNtopOffset,   5); n++;
    XtSetArg(args[n], XmNbottomAttachment, XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,  dismiss); n++;
    XtSetArg(args[n], XmNbottomOffset,   5); n++;
    XtSetArg(args[n], XmNwidth, 100); n++;
    XtSetArg(args[n], XmNheight, 40); n++;

    Widget text = XmCreateTextField(Form, "WindowName", args, n);

    XtAddCallback(text, XmNactivateCallback, 
        (XtCallbackProc ) mcfPlotWindow::setWindowNameCB,
        (XtPointer *) window);
    XtManageChild(text);    
    XtManageChild(Form);
}
void mcfPlotWindow::setWindowNameCB(Widget w, XtPointer *data, XtPointer *)
{
    mcfPlotWindow *win = (mcfPlotWindow *) data;
    char *text, *temp;
    if(text = XmTextGetString(w))
    {
       mcfMainPanel::RemovePlotFromList(win->getWindowName());
       win->setWindowName(text);
       mcfMainPanel::AddPlotToList(win->getWindowName());

    }
    return;
}
void mcfPlotWindow::dismissNameWindowCB(Widget, XtPointer *data, XtPointer *)
{
    Widget wForm = (Widget) data;
    XtDestroyWidget(XtParent(wForm));
    return;
}
static void plotWindowCB( Widget, XtPointer *data, XtPointer *)
{
    mcfPlotWindow *win; 
    mcfDisplay *display;
    SoXtViewer *viewer;
    mcfFile *File;
    Widget shell = SoXt::getTopLevelWidget();
    ivMenuItem *menudata = (ivMenuItem *) data;
    win = (mcfPlotWindow *)menudata->mcfWin;
    viewer = win->mcfPlotGetViewer();
    display = win->getDisplay();

    switch (menudata->id) {

    //
    // File
    //
 
    case PW_FILE_SAVE_IV:
        File = new mcfFile;
        File -> OutputInventorFile(shell, display->getGeometry());
        delete File;   
	break;

    case PW_FILE_SAVE_PS:
        File = new mcfFile;
        File -> OutputPostscriptFile(shell, display->getGeometry(), 
                                     win->mcfPlotGetViewer());
        delete File;   
	break;

//    case PW_FILE_NEXT_EVENT:
//        if(mcfFile::GetNextEvent()==0)
//        {
//           eventInformation *eventInfo = eventInformation::eventInfo();
//           eventInfo->updateEventInformation();
//           displayType donext = {SAMEPLOT, NEXTEVENT};
//           mcfDisplayList::mcfDisplayUpdateAll(donext, donext,donext);
//	   resetPickParameters();
//        }
//	break;

    case PW_FILE_CLOSE:
        win = (mcfPlotWindow *)menudata->mcfWin;
        mcfDisplayList::deleteDisplay(win);
        break;

    case PW_FILE_QUIT:
        exit(0);
    //
    // Plot
    //

    case PW_PLOT_MODIFY_TRACE:
        if (display->tracePlotType() != NOPLOT)
        {
            mcfTraceModifyWindow *traceWindow = 
                       new mcfTraceModifyWindow(win);
        }
        else
        {
            DialogF(DF_INF, shell, 1,
           "Trace Plot not active in this window",
	    "OK"); 
           
        }
  	break;

    case PW_PLOT_MODIFY_CAL:
        if (display->calPlotType() != NOPLOT)
        {
          mcfCalModifyWindow *calWindow = 
                       new mcfCalModifyWindow(win);
        }
        else
        {
            DialogF(DF_INF, shell, 1,
           "Calorimeter hit plot not active in this window",
	    "OK"); 
           
        }
 	break;

    case PW_PLOT_MODIFY_DETECTOR:
        if (display->detectorPlotType() != NOPLOT)
        {
        mcfDetectorModifyWindow *detWindow = 
                       new mcfDetectorModifyWindow(win);
        }
        else
        {
            DialogF(DF_INF, shell, 1,
           "Detector plot not active in this window",
	    "OK"); 
           
        }
 	break;

//
//Viewer
//
    case PW_RENAME_WINDOW:
         mcfPlotWindow::makeWindowNameText(win);
         break;
    case PW_WHITE_BACKGROUND:
         viewer->setBackgroundColor(SbColor(1.,1.,1.));
         break;
    case PW_BLACK_BACKGROUND:
         viewer->setBackgroundColor(SbColor(0.,0.,0.));
         break;
    case PW_SCREEN_DOOR:
         viewer->setTransparencyType
         (SoGLRenderAction::SCREEN_DOOR);
         break;
    case PW_DELAYED_BLEND:
         viewer->setTransparencyType
         (SoGLRenderAction::DELAYED_BLEND);
         break;
    case PW_SORTED_OBJECT_BLEND:
         viewer->setTransparencyType
         (SoGLRenderAction::SORTED_OBJECT_BLEND);
         break;
    case PW_NO_ANTIALIASING:
         viewer->setAntialiasing(FALSE, 1);
         break;
    case PW_ANTIALIASING:
         viewer->setAntialiasing(TRUE, 20);
         break;

 
    case PW_HELP_FILE:
      DialogF(DF_INF, shell, 1,
      "To save output from this plot or to close the plot, select File Menu",
	    "OK"); 
       break;

    case PW_HELP_PLOT:
      DialogF(DF_INF, shell, 1,
             "To modify a plot, select the Plot Menu to get dialog",
	    "OK"); 
       break;

    case PW_HELP_VIEWER:
      DialogF(DF_INF, shell, 1,
             "The plot window contains an ExaminerViewer with 3d controls",
	    "OK"); 
       break;
    }
    
}
