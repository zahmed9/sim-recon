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
#include "mcfTraceModifyWindow.hh"
#include "misc.h"
extern "C" {
#include "DialogF.h"
}
//set default for the number of decimal places on scale
const float SCALE = 10.;
//set default for the max pt scale 
const float ptScaleMax = 10.;
enum plotTraceModifyMenuEntries {
    TW_HELP,
    TW_HELP_OVERALL,

    TW_MENU_NUM		// this must be the last entry
};

mcfTraceModifyWindow::~mcfTraceModifyWindow(void)
{
    delete [] cbData;
}
static char RadioNames[][20] =
{
   "Trace",
   "Track",
   "Neutral",  
   "P/PT Cut"
};
void mcfTraceModifyWindow::makeMcfWindow(Widget main)
{

// define the buttons and the pulldowns
static ivButton buttonData[] = {
   {"About...", TW_HELP_OVERALL,  IV_PUSH_BUTTON, "", ""}
};
static ivMenu pulldownData[] = {
// {name, id, subMenu, subItemCount}
   {"Help",  TW_HELP, buttonData, 1 }
};
static togNames OnOff[2] =
{
    "Off",
    "On"
};
static togNames pPT[2] = 
{ 
     "P",
     "PT"
};
const int NTRACEBOXES = 4;
int i;
int set[NTRACEBOXES][2];

//figure out which toggle button should set for each trace type
      for( i = 0; i < NTRACEBOXES; i++)
      {
         set[i][0] = 0;
         set[i][1] = 0; 
      }
      set[0][traceInfo.PlotTrace] = 1;
      set[1][traceInfo.PlotTrack] = 1;
      set[2][traceInfo.PlotNeutr] = 1;
      set[3][(int)traceInfo.MomType] = 1;

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
     form = MakeFormDialog(main, 350, 550, "TraceModify");
     int n = 0;
     Arg args[10];
     XtSetArg(args[n], XmNautoUnmanage,  False); n++;
     XtSetValues(form, args, n);

     
     Widget menuWidget = buildAndLayoutMenu(form, pulldownData,
                                                  XtNumber( pulldownData ),
                                                  (XtCallbackProc) 
                                                  plotTraceModifyMenuCB);

//make a label to give the user some guidance:


   str = XmStringCreate("Define Trace Types to Display", 
                         XmSTRING_DEFAULT_CHARSET);
   n = 0;
   XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNtopWidget,  menuWidget); n++;
   XtSetArg(args[n], XmNtopOffset,   8); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNleftOffset,   0); n++;
   XtSetArg(args[n], XmNlabelString, str); n++;


   Widget traceLabel = XmCreateLabel(form, string, args, n);
   XtManageChild(traceLabel);
   XmStringFree(str);

// make a rowcolumn widget to hold the radio boxes and associated labels

     Widget rowCol1 = BuildAndLayoutRowCol(form, "rowsRadio",
                                       traceLabel, //attach to top
                                       form, //attach to left
                                       0,   //top offset
                                       50,   //left offset
                                       2 );  //num of rows

//now put the labels and boxes in the rowcolumn widget

//All of the radio box information is stored for the four different
//boxes.  However the fourth one is the p/pt selection and doesn't belong
//with the first three.

     for(i = 0; i < NTRACEBOXES-1; i++)
     {
        sprintf(string,"%s",RadioNames[i]);
        str = XmStringCreate(string, XmSTRING_DEFAULT_CHARSET);
        Label = XmCreateLabel(rowCol1, string, NULL, 0);
        XtVaSetValues(Label, XmNlabelString, str, NULL);
        XtManageChild(Label);
        XmStringFree(str);
     }
     for(i = 0; i < NTRACEBOXES-1; i++) 
     { 
        sprintf(string,"%s_Rad",RadioNames[i]);
        RadioBox = BuildRadioBox(rowCol1,string, 
                                 2, OnOff, set[i],
                                 (XtCallbackProc) plotTraceInfoModify, 
                                 cbData); 
        XtManageChild(RadioBox);
         
     }




//make a second label to give the user some guidance:


   str = XmStringCreate("Define Eta and Momentum Cuts", 
                         XmSTRING_DEFAULT_CHARSET);
   n = 0;
   XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNtopWidget,  rowCol1); n++;
   XtSetArg(args[n], XmNtopOffset,   10); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNleftOffset,   0); n++;
   XtSetArg(args[n], XmNlabelString, str); n++;


   Widget momLabel = XmCreateLabel(form, string, args, n);
   XtManageChild(momLabel);
   XmStringFree(str);
   
//put in a rowcolumn widget to hold the pt box                                       
   Widget rowColPt = BuildAndLayoutRowCol(form, "rowsptRadio",
                                       momLabel, //attach to top
                                       form, //attach to left
                                       10,   //top offset
                                       30,   //left offset
                                       2 );  //num of rows

 //label and radio for pt widget
 
   sprintf(string,"%s",RadioNames[NTRACEBOXES-1]);
   str = XmStringCreate(string, XmSTRING_DEFAULT_CHARSET);
   Label = XmCreateLabel(rowColPt, string, NULL, 0);
   XtVaSetValues(Label, XmNlabelString, str, NULL);
   XtManageChild(Label);
   XmStringFree(str);

   sprintf(string,"%s_Rad",RadioNames[NTRACEBOXES-1]);
   RadioBox = BuildRadioBox(rowColPt,string, 
                               2, pPT, set[NTRACEBOXES-1],
                               (XtCallbackProc) plotTraceInfoModify, 
                                cbData); 
   XtManageChild(RadioBox);
   XtManageChild(rowColPt);

     
 // build rowcolumn widget to hold sliders
     
   Widget rowCol2 = BuildAndLayoutRowCol(form, "rowsforsliders",
                                     momLabel,
                                     rowColPt,
                                     20,
                                     70, 
                                     3 ); //number of rows
   EtaMinScale = MakeScale(rowCol2, "Eta Minimum", -100, 100,
                                     (traceInfo.EtaMin * SCALE), 1);
                                     
   XtAddCallback(EtaMinScale,XmNvalueChangedCallback,
                    (XtCallbackProc) plotTraceScaleModify,
                    ( XtPointer *) this);

   EtaMaxScale = MakeScale(rowCol2, "Eta Maximum", -100, 100,
                                      (traceInfo.EtaMax * SCALE), 1);
   XtAddCallback(EtaMaxScale,XmNvalueChangedCallback,
                    (XtCallbackProc) plotTraceScaleModify,
                    ( XtPointer *) this);
   
   ptScale = MakeScale(rowCol2, "Momentum Cut", 00,(int) (ptScaleMax*SCALE), 
                                       (traceInfo.MomMin * SCALE), 1);
   XtAddCallback(ptScale,XmNvalueChangedCallback,
                    (XtCallbackProc) plotTraceScaleModify,
                    ( XtPointer *) this);

   XtManageChild(rowCol1);
   XtManageChild(rowCol2);

//put in a text field  and label for changing the pt scale max
   str = XmStringCreate("P/PT Scale Max", 
                         XmSTRING_DEFAULT_CHARSET);
   n = 0;
   XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNtopWidget,  rowColPt); n++;
   XtSetArg(args[n], XmNtopOffset,   10); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNleftWidget,  form); n++;
   XtSetArg(args[n], XmNleftOffset,   5); n++;
   XtSetArg(args[n], XmNlabelString, str); n++;


   Widget maxLabel = XmCreateLabel(form, string, args, n);
   XtManageChild(maxLabel);
   XmStringFree(str);
   


   n = 0;
   sprintf(string, "%3.1f", ptScaleMax);
   XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNtopWidget,  maxLabel); n++;
   XtSetArg(args[n], XmNtopOffset,   0); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNleftWidget,  form); n++;
   XtSetArg(args[n], XmNleftOffset,   5); n++;
   XtSetArg(args[n], XmNvalue, string); n++;

   Widget maxText = XmCreateText(form,"maxText", args, n);
   XtManageChild(maxText);

   XtAddCallback ( maxText, XmNactivateCallback, 
                   (XtCallbackProc )maxTextCB, 
                   (XtPointer *) this);  //change value of max for scale
                                         //widget


//put in a separator for visual clarity
    n = 0;
    XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNtopWidget,  rowCol2); n++;
    XtSetArg(args[n], XmNtopOffset,   20); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNseparatorType,  XmSINGLE_LINE); n++;

    Widget separator = XmCreateSeparator(form, "separator", args, n);
    XtManageChild(separator);

 // set up buttons for action

    Widget ok = MakeDialogButton(form, "Ok     ", 
    (XtCallbackProc)plotTraceOkCB,
    (XtPointer *) this, form, 20);  

    Widget apply = MakeDialogButton(form, "Apply  ", 
    (XtCallbackProc)plotTraceApplyCB,
    (XtPointer *) this, ok, 30);  

    Widget dimiss = MakeDialogButton(form, "Dismiss", 
    (XtCallbackProc)plotTraceDismissCB,
    (XtPointer *) this, apply, 30);  

    XtManageChild(form);
    return;
      
   
}
void mcfTraceModifyWindow::getScales(void)
{
      int temp;
      XmScaleGetValue(EtaMinScale, &temp);
      traceInfo.EtaMin = (double) temp/SCALE;

      XmScaleGetValue(EtaMaxScale, &temp);
      traceInfo.EtaMax = (double) temp/SCALE;

      XmScaleGetValue(ptScale, &temp);
      traceInfo.MomMin = (double) temp/SCALE;
      return;
      
};

static void plotTraceModifyMenuCB( Widget, XtPointer *data, XtPointer *)
{
    ivMenuItem *menudata = (ivMenuItem *) data;
    mcfTraceModifyWindow *win = (mcfTraceModifyWindow *)menudata->mcfWin;
    mcfPlotWindow *plot = win->GetPlot(); 
    switch (menudata->id) {


    case TW_HELP_OVERALL:
      DialogF(DF_INF, plot->getShell(), 1,
      "This panel allows you to modify parameters\n for the display of traces",
	    "OK"); 
       break;

    }
    
}
static void plotTraceApplyCB( Widget, XtPointer *data, XtPointer *)
{
      mcfTraceModifyWindow *window = (mcfTraceModifyWindow *) data;
      mcfPlotWindow *plot = window->GetPlot();
      
      //get the values of the sliders
      
      window->getScales();
      plot->updatePlotWindowTrace(window->traceInfo);
      return;
      
}
static void plotTraceOkCB( Widget, XtPointer *data, XtPointer *)
{
      mcfTraceModifyWindow *window = (mcfTraceModifyWindow *) data;
      mcfPlotWindow *plot = window->GetPlot();
      
      //get the values of the sliders
      
      window->getScales();
      plot->updatePlotWindowTrace(window->traceInfo);
      XtDestroyWidget(XtParent(window->getForm()));
      delete window;
      return;
      
}
static void plotTraceDismissCB( Widget, XtPointer *data, XtPointer *)
{
      mcfTraceModifyWindow *window = (mcfTraceModifyWindow *) data;
      mcfPlotWindow *plot = window->GetPlot();
      XtDestroyWidget(XtParent(window->getForm()));
      delete window;
      return;
      
}
static void plotTraceInfoModify
                   ( Widget w, XtPointer *data, XtPointer *callData)
{
       XmToggleButtonCallbackStruct *state = 
                        ( XmToggleButtonCallbackStruct *) callData;
       toggleButtonCbData *cldata = (toggleButtonCbData *) data;

       mcfTraceModifyWindow *window = (mcfTraceModifyWindow *)cldata->window; 
       int setting = cldata->setting;
       if(state->set)
       {
          
          if(strstr( XtName(XtParent(w)), RadioNames[0] ) != NULL)
          {
             window->traceInfo.PlotTrace = setting;
          }
          else if (strstr( XtName(XtParent(w)), RadioNames[1] ) != NULL )
          {
             window->traceInfo.PlotTrack = setting;
          }
          else if (strstr( XtName(XtParent(w)), RadioNames[2] ) != NULL )
          {
             window->traceInfo.PlotNeutr = setting;
          }
          else if (strstr( XtName(XtParent(w)), RadioNames[3] ) != NULL )
          {
             window->traceInfo.MomType = (momType) setting;
          }
	  //update plot automatically
	   mcfPlotWindow *plot = window->GetPlot();

	  //get the values of the sliders

	   window->getScales();
	   plot->updatePlotWindowTrace(window->traceInfo);
       }
       
        return;

}
static void plotTraceScaleModify
                   ( Widget, XtPointer *data, XtPointer *)
{



       mcfTraceModifyWindow *window = (mcfTraceModifyWindow *) data; 
       //update plot automatically
 
       mcfPlotWindow *plot = window->GetPlot();
      
       //get the values of the sliders, I should just get the one
       //that changed...
      
       window->getScales();
       plot->updatePlotWindowTrace(window->traceInfo);
       return;

}

static void maxTextCB( Widget w, XtPointer *data, XtPointer *)
{
    char *text;
    float scale;
    Arg args[5];
    int value; 
    int n = 0; 
    
    
    if( text = XmTextGetString(w) )
    {
       if( isdigit(value = text[0]) )
       {
          sscanf(text, "%f", &scale);
          mcfTraceModifyWindow *win = 
               (mcfTraceModifyWindow *) data;

          XtSetArg(args[n], XmNmaximum, scale * SCALE); n++;
          XtSetValues(win->ptScale, args, n);

       }
       XtFree (text);
    }
} 
