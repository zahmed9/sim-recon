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
#include "mcfDisplayList.hh"
#include "ivButton.hh"
#include "mcfCalModifyWindow.hh"
#include "misc.h"
extern "C" {
#include "DialogF.h"
}

enum plotCalModifyMenuEntries {
    CW_HELP,
    CW_HELP_OVERALL,

    CW_MENU_NUM		// this must be the last entry
};
struct textCbData
{
   mcfCalModifyWindow *win;
   Widget w;
};

mcfCalModifyWindow::~mcfCalModifyWindow(void)
{
    delete [] cbData;
}
static char RadioNames[][20] =
{
   "E/ET",
   "Frame",
};
void mcfCalModifyWindow::makeMcfWindow(Widget main)
{

// define the buttons and the pulldowns
static ivButton buttonData[] = {
   {"About...", CW_HELP_OVERALL,  IV_PUSH_BUTTON, "", ""}
};
static ivMenu pulldownData[] = {
// {name, id, subMenu, subItemCount}
   {"Help",  CW_HELP, buttonData, 1 }
};
static togNames OnOff[2] =
{
    "Off",
    "On"
};
static togNames eET[2] = 
{ 
     "E",
     "ET"
};
const int NCALBOXES = 2;
int i;
int set[NCALBOXES][2];

//figure out which toggle button should set for each type
      for( i = 0; i < NCALBOXES; i++)
      {
         set[i][0] = 0;
         set[i][1] = 0; 
      }
      set[0][(int)calInfo.dispEorEt] = 1;
      set[1][(int)calInfo.dispFrame] = 1;

// allocate and fill structure for callback data;


     cbData = new toggleButtonCbData[2];
     for( i = 0; i < 2; i++ )
     {
         cbData[i].window = this;
         cbData[i].setting = i;
     }     


     Widget Label;
     Widget RadioBox;
     XmString str;
     char string[20];
// Now do the work
     form = MakeFormDialog(main, 300, 350, "Calorimeter Hits Modify");
     int n = 0;
     Arg args[10];
     XtSetArg(args[n], XmNautoUnmanage,  False); n++;
     XtSetValues(form, args, n);

     
     Widget menuWidget = buildAndLayoutMenu(form, pulldownData,
                                                  XtNumber( pulldownData ),
                                                  (XtCallbackProc) 
                                                  plotCalModifyMenuCB);

//make a label to give the user some guidance:


   str = XmStringCreate("Modify Calorimeter Parameters", 
                         XmSTRING_DEFAULT_CHARSET);
   n = 0;
   XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNtopWidget,  menuWidget); n++;
   XtSetArg(args[n], XmNtopOffset,   8); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
   //XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNleftOffset,   10); n++;
   XtSetArg(args[n], XmNlabelString, str); n++;


   Widget calLabel = XmCreateLabel(form, "CalModLabel", args, n);
   XtManageChild(calLabel);
   XmStringFree(str);

// make a rowcolumn widget to hold the radio boxes and associated labels

     Widget rowCol1 = BuildAndLayoutRowCol(form, "rowsRadio",
                                       calLabel, //attach to top
                                       form, //attach to left
                                       0,   //top offset
                                       50,   //left offset
                                       2 );  //num of rows

//now put the label and boxe in the rowcolumn widget 

//E/Et label
     sprintf(string,"%s",RadioNames[0]);
     str = XmStringCreate(string, XmSTRING_DEFAULT_CHARSET);
     Label = XmCreateLabel(rowCol1, string, NULL, 0);
     XtVaSetValues(Label, XmNlabelString, str, NULL);
     XtManageChild(Label);
     XmStringFree(str);

// frame on/off label
     sprintf(string,"%s",RadioNames[1]);
     str = XmStringCreate(string, XmSTRING_DEFAULT_CHARSET);
     Label = XmCreateLabel(rowCol1, string, NULL, 0);
     XtVaSetValues(Label, XmNlabelString, str, NULL);
     XtManageChild(Label);
     XmStringFree(str);

//E/Et radio box
     sprintf(string,"%s_Rad",RadioNames[0]);
     RadioBox = BuildRadioBox(rowCol1,string, 
                              2, eET, set[0],
                              (XtCallbackProc) plotCalInfoModify, 
                              cbData); 
     XtManageChild(RadioBox);


//frame radio box
     sprintf(string,"%s_Rad",RadioNames[1]);
     RadioBox = BuildRadioBox(rowCol1,string, 
                              2, OnOff, set[1],
                              (XtCallbackProc) plotCalInfoModify, 
                              cbData); 
     XtManageChild(RadioBox);
     XtManageChild(rowCol1);


//put in a text field  and label for changing the pt scale thresh
   str = XmStringCreate("E/ET Threshold in GeV", 
                         XmSTRING_DEFAULT_CHARSET);
   n = 0;
   XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNtopWidget, rowCol1 ); n++;
   XtSetArg(args[n], XmNtopOffset,   10); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNleftWidget,  form); n++;
   XtSetArg(args[n], XmNleftOffset,   5); n++;
   XtSetArg(args[n], XmNlabelString, str); n++;


   Widget threshLabel = XmCreateLabel(form, string, args, n);
   XtManageChild(threshLabel);
   XmStringFree(str);
   


   n = 0;
   sprintf(string, "%f", calInfo.threshold);
   XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNtopWidget,  threshLabel); n++;
   XtSetArg(args[n], XmNtopOffset,   0); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNleftWidget,  form); n++;
   XtSetArg(args[n], XmNleftOffset,   5); n++;
   XtSetArg(args[n], XmNvalue, string); n++;

   Widget threshText = XmCreateText(form,"threshText", args, n);
   XtManageChild(threshText);

   XtAddCallback ( threshText, XmNactivateCallback, 
                   (XtCallbackProc )calThresholdCB, 
                   (XtPointer *) this);  //change value of threshold
 

//put in a separator for visual clarity
    n = 0;
    XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNtopWidget,  threshText); n++;
    XtSetArg(args[n], XmNtopOffset,   20); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNseparatorType,  XmSINGLE_LINE); n++;

    Widget separator = XmCreateSeparator(form, "separator", args, n);
    XtManageChild(separator);

 // set up buttons for action

    textCbData *cdata = new textCbData;
    cdata->win= this;
    cdata->w = threshText;
    Widget ok = MakeDialogButton(form, "Ok     ", 
    (XtCallbackProc)plotCalOkCB,
    (XtPointer *) cdata, form, 20);  

    Widget apply = MakeDialogButton(form, "Apply  ", 
    (XtCallbackProc)plotCalApplyCB,
    (XtPointer *) cdata, ok, 20);  

    Widget dimiss = MakeDialogButton(form, "Dismiss", 
    (XtCallbackProc)plotCalDismissCB,
    (XtPointer *) this, apply, 20);  

    XtManageChild(form);
    return;
      
   
}

static void plotCalModifyMenuCB( Widget, XtPointer *data, XtPointer *)
{
    ivMenuItem *menudata = (ivMenuItem *) data;
    mcfCalModifyWindow *win = (mcfCalModifyWindow *)menudata->mcfWin;
    mcfPlotWindow *plot = win->GetPlot(); 
    switch (menudata->id) {


    case CW_HELP_OVERALL:
      DialogF(DF_INF, plot->getShell(), 1,
      "This panel allows you to modify parameters\n for the calorimeter hits",
	    "OK"); 
       break;

    }
    
}
static void plotCalApplyCB( Widget, XtPointer *data, XtPointer *)
{
     char *text;
     float thresh;
      textCbData *cbdata = (textCbData *) data;
      mcfCalModifyWindow *window = (mcfCalModifyWindow *) cbdata->win;
      Widget w = (Widget) cbdata->w;
   
      if( text = XmTextGetString(w) )
      {
       if( isdigit(text[0]) )
       {
          sscanf(text, "%f", &thresh);
 
          window->calInfo.threshold = thresh;
       }
       XtFree (text);
      }

      
      mcfPlotWindow *plot = window->GetPlot();     
      plot->updatePlotWindowCalHits(window->calInfo);
      return;
      
}
static void plotCalOkCB( Widget, XtPointer *data, XtPointer *)
{
     char *text;
     float thresh;
     textCbData *cbdata = (textCbData *) data;
      mcfCalModifyWindow *window = (mcfCalModifyWindow *) cbdata->win;
      Widget w = (Widget) cbdata->w;
   
      if( text = XmTextGetString(w) )
      {
       if( isdigit(text[0]) )
       {
          sscanf(text, "%f", &thresh);
 
          window->calInfo.threshold = thresh;
       }
       XtFree (text);
      }

      mcfPlotWindow *plot = window->GetPlot();     
      plot->updatePlotWindowCalHits(window->calInfo);
      XtDestroyWidget(XtParent(window->getForm()));
      delete data;
      delete window;
      return;
      
}
static void plotCalDismissCB( Widget, XtPointer *data, XtPointer *)
{
      mcfCalModifyWindow *window = (mcfCalModifyWindow *) data;
      XtDestroyWidget(XtParent(window->getForm()));
      delete window;
      return;
      
}
static void plotCalInfoModify
                   ( Widget w, XtPointer *data, XtPointer *callData)
{
       XmToggleButtonCallbackStruct *state = 
                        ( XmToggleButtonCallbackStruct *) callData;
       toggleButtonCbData *cldata = (toggleButtonCbData *) data;

       mcfCalModifyWindow *window = (mcfCalModifyWindow *)cldata->window; 
       int setting = cldata->setting;
       if(state->set)
       {
          
          if(strstr( XtName(XtParent(w)), RadioNames[0] ) != NULL)
          {
             window->calInfo.dispEorEt = (momType) setting;
          }
          else if (strstr( XtName(XtParent(w)), RadioNames[1] ) != NULL )
          {
             window->calInfo.dispFrame = (toggleType) setting;
          }
	  //update plot automatically
	  mcfPlotWindow *plot = window->GetPlot();

	  plot->updatePlotWindowCalHits(window->calInfo);
 
       }
       
      return;

}
static void calThresholdCB( Widget w, XtPointer *data, XtPointer *)
{
    char *text;
    float thresh;
    
    
    if( text = XmTextGetString(w) )
    {
       if( isdigit(text[0]) )
       {
          sscanf(text, "%f", &thresh);
          mcfCalModifyWindow *window = 
               (mcfCalModifyWindow *) data;

          window->calInfo.threshold = thresh;

//update:
          mcfPlotWindow *plot = window->GetPlot();
          plot->updatePlotWindowCalHits(window->calInfo);
          
       }
       XtFree (text);
    }
} 
