#include <stdio.h>
#include <ctype.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include <Inventor/Xt/viewers/SoXtExaminerViewer.h>
#include <Xm/RowColumn.h>
#include <Xm/Separator.h>
#include <Xm/Scale.h>
#include <Xm/Text.h>
#include <Xm/TextF.h>
#include "ivButton.hh"
#include "mcfPickInfoWindow.hh"
#include "misc.h"
extern "C" {
#include "DialogF.h"
}


//storage for static variable
mcfPickInfoWindow *mcfPickInfoWindow::_pickInfoWindow = NULL;
enum plotPickInfoMenuEntries {
    PI_HELP,
    PI_HELP_OVERALL,

    PI_MENU_NUM		// this must be the last entry
};

//
mcfPickInfoWindow *mcfPickInfoWindow::pickInfoWindow(Widget parent)
{
    if(_pickInfoWindow == NULL)
    _pickInfoWindow = new mcfPickInfoWindow(parent);
    
    if(_pickInfoWindow->GetPopped() == 0)
    {
       _pickInfoWindow->Show();
    }

    
    return _pickInfoWindow;
}


void mcfPickInfoWindow::makeMcfWindow(Widget main)
{

// define the buttons and the pulldowns
static ivButton buttonData[] = {
   {"About...", PI_HELP_OVERALL,  IV_PUSH_BUTTON, "", ""}
};
static ivMenu pulldownData[] = {
// {name, id, subMenu, subItemCount}
   {"Help",  PI_HELP, buttonData, 1 }
};
// Now do the work
   Shell = MakeDetachedShell( main, "Pick Information" );
   form = MakeForm(Shell, 500, 400);
   int n = 0;
   Arg args[10];


   Widget menuWidget = buildAndLayoutMenu(form, pulldownData,
                                                XtNumber( pulldownData ),
                                                (XtCallbackProc) 
                                                          pickInfoMenuCB);
// button for dismissing panel
    Widget dismiss = MakeDialogButton(form, "Dismiss", 
    (XtCallbackProc)pickInfoDismissCB,
    (XtPointer *) this, form, 85);  

//put in a separator for visual clarity
    n = 0;
    XtSetArg(args[n], XmNbottomAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,  dismiss); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNseparatorType,  XmSINGLE_LINE); n++;

    Widget separator = XmCreateSeparator(form, "separator", args, n);
    XtManageChild(separator);

// put in a scrolled window to hold the text


     scrolledText = BuildAndLayoutScrolledText(form, 
                                     menuWidget,  //top attachment
                                     separator,  //bottom attachment
                                     10,         //top offset
                                     10,         //bottom offset
                                     "PickText");




    XtManageChild(form);
    XtRealizeWidget(Shell); 
    return;
      
   
}

void mcfPickInfoWindow::updateText(const char *name)
{
     XMapRaised(XtDisplay(Shell), XtWindow(Shell));
     XmTextSetString(scrolledText, "\000");
     XmTextSetString(scrolledText, (char *) name);

}

static void pickInfoMenuCB( Widget, XtPointer *data, XtPointer *)
{
    ivMenuItem *menudata = (ivMenuItem *) data;
    mcfPickInfoWindow *win = (mcfPickInfoWindow *)menudata->mcfWin;
     
    switch (menudata->id) {


    case PI_HELP_OVERALL:
      DialogF(DF_INF, XtParent(win->getForm()), 1,
      "This panel displays information from picking",
	    "OK"); 
       break;

    }
    
}
static void pickInfoDismissCB( Widget, XtPointer *data, XtPointer *)
{
      mcfPickInfoWindow *window = (mcfPickInfoWindow *) data;
      window->SetPopped(0);
      window->Hide();

      return;
      
}


