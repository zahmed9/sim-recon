#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include <Inventor/Xt/viewers/SoXtExaminerViewer.h>
#include <X11/Intrinsic.h>
#include <X11/Xatom.h>
#include <Xm/Xm.h>
#include <Xm/ArrowB.h>
#include <Xm/TextF.h>
#include <Xm/List.h>
#include "mcfFile.hh"
#include "mcfPlotDefine.hh"
#include "mcfDisplayList.hh"
#include "ivButton.hh"
#include "mcfMainPanel.hh"
#include "displayTypes.hh"
#include "eventInformation.hh"
#include "resetPickParameters.hh"
extern "C" {
#include "DialogF.h"
}
enum mainPanelEntries {
    MP_FILE = 0,
    MP_FILE_OPEN_MCFIO,
    MP_FILE_OPEN_DBIN,
//    MP_FILE_OPEN_IV,
    MP_FILE_NEXT_EVENT,
    MP_FILE_QUIT,

    MP_PLOT,
    MP_PLOT_DEFINE,

    MP_HELP,
    MP_HELP_ABOUT,
    MP_HELP_FILE,
    MP_HELP_PLOT,

    MP_MENU_NUM		// this must be the last entry
};
Widget mcfMainPanel::scrolledList = NULL;

void mcfMainPanel::makeMcfWindow(Widget main)
{

// define the buttons and the pulldowns
static ivButton buttonData[] = {
   {"Read MCfio File...", MP_FILE_OPEN_MCFIO, IV_PUSH_BUTTON,"Alt <Key> m", "Alt+m"},
   {"Read Dbin File...",  MP_FILE_OPEN_DBIN,  IV_PUSH_BUTTON, "Alt <Key> d", "Alt+d" },
//   {"Read .iv Geometry File...",  MP_FILE_OPEN_IV,  IV_PUSH_BUTTON, "", "" },
   {"Get Next Event.",  MP_FILE_NEXT_EVENT,  IV_PUSH_BUTTON, "Alt <Key> n", "Alt+n" },
   {"Quit",     MP_FILE_QUIT,  IV_PUSH_BUTTON, "Alt <Key> q", "Alt+q"},
   {"Define Plot", MP_PLOT_DEFINE, IV_PUSH_BUTTON,"Alt <Key> p", "Alt+p"},
   {"About this Display", MP_HELP_ABOUT,  IV_PUSH_BUTTON, "", ""},
   {"File", MP_HELP_FILE,  IV_PUSH_BUTTON, "", ""},
   {"Plot", MP_HELP_PLOT,  IV_PUSH_BUTTON, "", ""}
};
static ivMenu pulldownData[] = {
// {name, id, subMenu, subItemCount}
   {"File",  MP_FILE, buttonData, 4 },
   {"Plot",  MP_PLOT, buttonData + 4, 1 },
   {"Help",  MP_HELP, buttonData + 5, 3 }
};
// Now do the work

   Widget form = MakeForm(main, 520, 200);

   Widget menuWidget = buildAndLayoutMenu(form, pulldownData,
                                          XtNumber( pulldownData ),
                                          (XtCallbackProc)
                                          mcfMainPanel::mainPanelCB); 
   int n=0; Arg args[30];
   XtSetArg(args[n], XmNarrowDirection, XmARROW_LEFT); n++;
   XtSetArg(args[n], XmNbottomAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNbottomOffset,   10); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNleftWidget,  form); n++;
   XtSetArg(args[n], XmNleftOffset,   10); n++;
   XtSetArg(args[n], XmNwidth, 30); n++;
   XtSetArg(args[n], XmNheight,30); n++;

   leftArrow = XmCreateArrowButton(form, "leftarrow", args, n);                                       
   XtAddCallback(leftArrow, XmNarmCallback, 
   (XtCallbackProc )mcfMainPanel::decrementEventCB, 
   (XtPointer *) this);

   n=0;
   XtSetArg(args[n], XmNbottomAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNbottomOffset,   5); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNleftWidget,  leftArrow); n++;
   XtSetArg(args[n], XmNleftOffset,   0); n++;
   XtSetArg(args[n], XmNwidth, 60); n++;
   XtSetArg(args[n], XmNheight, 40); n++;
   eventText = XmCreateTextField(form, "eventText", args, n);    
   XtAddCallback(eventText, XmNactivateCallback, 
   (XtCallbackProc ) mcfMainPanel::specificEventCB,
   (XtPointer *) this);

 
   n=0;
   XtSetArg(args[n], XmNarrowDirection, XmARROW_RIGHT); n++;
   XtSetArg(args[n], XmNbottomAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNbottomOffset,   10); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNleftWidget,  eventText); n++;
   XtSetArg(args[n], XmNleftOffset,   0); n++;
   XtSetArg(args[n], XmNwidth, 30); n++;
   XtSetArg(args[n], XmNheight, 30); n++;

   rightArrow = XmCreateArrowButton(form, "rightarrow", args, n);
   XtAddCallback(rightArrow, XmNarmCallback, 
   (XtCallbackProc ) mcfMainPanel::incrementEventCB,
   (XtPointer *) this);
   
    Widget exit = MakeDialogButton(form, "Exit", 
    (XtCallbackProc) mcfMainPanel::exitMcfIV,
    NULL, rightArrow, 200);  

   
   n=0;
   XtSetArg(args[n], XmNbottomAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNbottomWidget,  eventText); n++;
   XtSetArg(args[n], XmNbottomOffset,   10); n++;
   XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNtopWidget,  menuWidget); n++;
   XtSetArg(args[n], XmNtopOffset,   10); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNleftOffset,  10); n++;
   XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNrightOffset,  10); n++;
   
   scrolledList = XmCreateScrolledList(form, "PlotList", args, n);
   
   XtManageChild(leftArrow);
   XtManageChild(eventText);
   XtManageChild(rightArrow);
   if(mcfFile::getNameOfFile() != NULL && !mcfFile::dbin())
   {
      changeTitle(SoXt::getTopLevelWidget(), mcfFile::getNameOfFile());
      char string[10];
      sprintf(string, "%d", mcfFile::getEventNumber());
      XmTextSetString(eventText, string);
      eventInformation *eventInfo = eventInformation::eventInfo();
      eventInfo->updateEventInformation();
   }
   else if(mcfFile::getNameOfFile() != NULL && mcfFile::dbin())
   {
      XtSetSensitive(leftArrow, False);
      XtSetSensitive(rightArrow, False);
      XtSetSensitive(eventText, False);
      changeTitle(SoXt::getTopLevelWidget(), mcfFile::getNameOfFile());    
   }
   else
   {
      XtSetSensitive(leftArrow, False);
      XtSetSensitive(rightArrow, False);
      XtSetSensitive(eventText, False);
   }
   
   XtManageChild(scrolledList);
 
   XtManageChild(form); 
      
   
     
};
void mcfMainPanel::mainPanelCB( Widget, XtPointer *data, XtPointer *)
{
    char string[132];
    Widget shell = SoXt::getTopLevelWidget();
    ivMenuItem *menudata = (ivMenuItem *) data;
    mcfMainPanel *panel = (mcfMainPanel *) menudata->mcfWin;
    switch (menudata->id) {

    //
    // File
    //
 
    case MP_FILE_OPEN_MCFIO:
        mcfFile::GetOpenAndReadMcfio(shell);
        if(mcfFile::getNameOfFile() != NULL)
        {
             panel->changeTitle(shell, mcfFile::getNameOfFile());
	     XtSetSensitive(panel->leftArrow, True);
	     XtSetSensitive(panel->rightArrow, True);
	     XtSetSensitive(panel->eventText, True);
             eventInformation *eventInfo = eventInformation::eventInfo();
             eventInfo->updateEventInformation();
             displayType donext = {SAMEPLOT, NEXTEVENT};
             mcfDisplayList::mcfDisplayUpdateAll(donext, donext, donext);
             int event = mcfFile::getEventNumber();
	     sprintf(string, "%d", event);
	     XmTextSetString(panel->eventText, string);
         }
	break;

    case MP_FILE_OPEN_DBIN:
        mcfFile::GetOpenAndReadDbin(shell);
        if(mcfFile::getNameOfFile() != NULL)
        {
             panel->changeTitle(shell, mcfFile::getNameOfFile());
	     XtSetSensitive(panel->leftArrow, False);
	     XtSetSensitive(panel->rightArrow, False);
	     XtSetSensitive(panel->eventText, False);
        }
	break;


    case MP_FILE_NEXT_EVENT:
        if(mcfFile::GetNextEvent()==0)
        {
           eventInformation *eventInfo = eventInformation::eventInfo();
           eventInfo->updateEventInformation();
           displayType donext = {SAMEPLOT, NEXTEVENT};
           mcfDisplayList::mcfDisplayUpdateAll(donext, donext, donext);
           int event = mcfFile::getEventNumber();
	   sprintf(string, "%d", event);
	   XmTextSetString(panel->eventText, string);
	   resetPickParameters();
        }
	break;

    case MP_FILE_QUIT:
        exit(0);
    //
    // Plot
    //

    case MP_PLOT_DEFINE:
       mcfPlotDefine *plotBox = new mcfPlotDefine;
       plotBox -> displayPlotDefinitionDialog(shell);
       break;

    case MP_HELP_ABOUT:
      DialogF(DF_INF, shell, 1,
      "This OpenInventor based event display is designed to work with McFast",
	    "OK");
	break;
	
    case MP_HELP_FILE:
      DialogF(DF_INF, shell, 1,
      "To get started, read in an McFio file or Dbin geometry file",
	    "OK"); 
       break;
    case MP_HELP_PLOT:
      DialogF(DF_INF, shell, 1,
             "To define a plot, select the Plot Menu to get dialog",
	    "OK"); 
       break;
    }
    
}
void mcfMainPanel::AddPlotToList(char *plotName)
{
     XmString text = XmStringCreateSimple(plotName);
     XmListAddItemUnselected( scrolledList,text,0);
     XmStringFree(text);
     return;
}
void mcfMainPanel::RemovePlotFromList(char *plotName)
{
     XmString text = XmStringCreateSimple(plotName);
     XmListDeleteItem( scrolledList,text);
     XmStringFree(text);
     return;
}
void mcfMainPanel::specificEventCB(Widget, XtPointer *userData, XtPointer* )
{
    mcfMainPanel *panel = (mcfMainPanel *) userData;
    int event;
    char *text;
    if(text = XmTextGetString(panel->eventText))
    {
      sscanf(text, "%d", &event);
      mcfFile::GetEvent(event); 
      eventInformation *eventInfo = eventInformation::eventInfo();
      eventInfo->updateEventInformation();
      displayType donext = {SAMEPLOT, NEXTEVENT}; 
      resetPickParameters();
      mcfDisplayList::mcfDisplayUpdateAll(donext, donext, donext);
    }
    XtFree(text);
    return;
         
}
void mcfMainPanel::decrementEventCB(Widget, XtPointer *userData, XtPointer* )
{
    mcfMainPanel *panel = (mcfMainPanel *) userData;
    int event = mcfFile::getEventNumber(); event--; 
    mcfFile::GetEvent(event);
    char string[10];
    sprintf(string, "%d", event);
    XmTextSetString(panel->eventText, string);
    eventInformation *eventInfo = eventInformation::eventInfo();
    eventInfo->updateEventInformation();
    displayType donext = {SAMEPLOT, NEXTEVENT};
    mcfDisplayList::mcfDisplayUpdateAll(donext, donext, donext);
    resetPickParameters();
    return; 
    
}
void mcfMainPanel::incrementEventCB(Widget, XtPointer *userData, XtPointer* )
{
    mcfMainPanel *panel = (mcfMainPanel *) userData;
    int event = mcfFile::getEventNumber(); event++; 
    mcfFile::GetEvent(event);
    char string[10];
    sprintf(string, "%d", event);
    XmTextSetString(panel->eventText, string);
    eventInformation *eventInfo = eventInformation::eventInfo();
    eventInfo->updateEventInformation();
    displayType donext = {SAMEPLOT, NEXTEVENT};
    mcfDisplayList::mcfDisplayUpdateAll(donext, donext, donext);
    resetPickParameters();
    return; 
}
