#include "mcfPlotDefine.hh"
#include "mcfFile.hh"
#include <Inventor/SoInput.h>
extern "C" {
#include "DialogF.h"
}
#include <Xm/Frame.h>
#include "mcfDisplayList.hh"
//need to find MAX_ARG in nirvana stuff?
const int MAX_ARG = 20;
void mcfPlotDefine::displayPlotDefinitionDialog(Widget parent)
{
    Arg args[MAX_ARG]; int n = 0;
    int i;
    Widget form = XmCreateFormDialog(parent, "PlotDefineForm", args, n);   
    XtVaSetValues(form, XmNwidth, 400, XmNheight, 400, NULL);

    //Calorimeter energy
    static plotDefineCbData calCbData[numCalType] =
    {
      {this, TDPLOT},
      {this, ETAPLOT},
      {this, PHIPLOT},
      {this, LEGOPLOT},
      {this, NOPLOT}
    };

    //Trace display
    static plotDefineCbData traceCbData[numTraceType] =
    {
      {this, TDPLOT},
      {this, RZPLOT},
      {this, RPHIPLOT},
      {this, MOMPLOT},
      {this, NOPLOT}
     };

    //detector display
    static plotDefineCbData detectorCbData[numDetectorType] =
    {
      {this, TDPLOT},
      {this, NOPLOT}
     };
 
    //Hits display
    static plotDefineCbData hitsCbData[numHitsType] =
    {
      {this, TDPLOT},
      {this, NOPLOT}
     };

// initalize pointer for callback.  This is a real mess--if two define plot
// windows are open at once, only the last plot will get defined correctly.
    for ( i = 0; i < numTraceType; i++ )
    {
       traceCbData[i].plotDefine = this;
    }
    for ( i = 0; i < numCalType; i++ )
    {
       calCbData[i].plotDefine = this;
    }
    for ( i = 0; i < numDetectorType; i++ )
    {
       detectorCbData[i].plotDefine = this;
    }
    for ( i = 0; i < numHitsType; i++ )
    {
       hitsCbData[i].plotDefine = this;
    }
//build from the bottom up: first buttons, then calor/trace 
//then detector/hits


//buttons for taking action

    XmString string1 = XmStringCreateSimple("Dismiss");
    n = 0;
    XtSetArg(args[n], XmNlabelString, string1 ); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   40); n++;
    XtSetArg(args[n], XmNbottomAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNwidth, 70); n++;
    XtSetArg(args[n], XmNheight, 40); n++;
    Widget button1 = XmCreatePushButton(form, "dismiss", args, n);
    XtManageChild(button1);
    XmStringFree(string1);
    
    XmString string2 = XmStringCreateSimple("Create Plot");
    n = 0;
    XtSetArg(args[n], XmNlabelString, string2 ); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,  button1); n++;
    XtSetArg(args[n], XmNleftOffset,   20); n++;
    XtSetArg(args[n], XmNbottomAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNwidth, 100); n++;
    XtSetArg(args[n], XmNheight, 40); n++;
        
    Widget button2 = XmCreatePushButton(form, "ok", args, n);
    XtAddCallback ( button2, XmNactivateCallback, 
                  (XtCallbackProc) plotDefineCB, 
                  (XtPointer) &traceCbData[0]); 
    XtManageChild(button2);
    XmStringFree(string2);

    XmString string3 = XmStringCreateSimple("Help");
    n = 0;
    XtSetArg(args[n], XmNlabelString, string3 ); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,  button2); n++;
    XtSetArg(args[n], XmNleftOffset,   20); n++;
    XtSetArg(args[n], XmNbottomAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNwidth, 70); n++;
    XtSetArg(args[n], XmNheight, 40); n++;
    Widget button3 = XmCreatePushButton(form, "xhelp", args, n);
    XtManageChild(button3);
    XmStringFree(string3);

//  make a frame
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,   XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,       button1); n++;
    XtSetArg(args[n], XmNbottomOffset,   20); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   30); n++;
    
    Widget calFrame = XtVaCreateManagedWidget("CalFrame", 
         xmFrameWidgetClass, form, XmNshadowType, XmSHADOW_ETCHED_OUT, NULL);

    XtSetValues(calFrame, args, n);

//  setup calorimeter box
//  put a label above the pox

    XmString str = XmStringCreate("Calorimeter Plot", 
    XmSTRING_DEFAULT_CHARSET);

    n = 0;
    XtSetArg(args[n], XmNlabelString,   str); n++;
    XtSetArg(args[n], XmNbottomAttachment,   XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,       calFrame); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   30); n++;
    
    Widget calLabel = XmCreateLabel(form, "callabel", args, n);
    
    XtSetValues(calLabel, args, n);
    XtManageChild(calLabel);
    XmStringFree(str);

    Widget calHitRadioBox = XmCreateRadioBox(calFrame, "calRadioBox", NULL, 0);

    Widget calToggles[numCalType];
    for (i = 0; i < numCalType; i++)
    {
        calToggles[i] = XtVaCreateManagedWidget( 
                        PlotNames[(int) calCbData[i].type] ,  
                        xmToggleButtonGadgetClass, 
                        calHitRadioBox, NULL);
        XtAddCallback ( calToggles[i], XmNvalueChangedCallback, 
                      (XtCallbackProc) calHitsCB, 
                      (XtPointer) &calCbData[i]); 
        
        XtSetSensitive(calToggles[i], PlotImplemented[(int) calCbData[i].type]);
        n = 0;
        if( i == numCalType - 1 )
        {
          XtSetArg(args[n], XmNset, True); n++;
          XtSetValues(calToggles[i], args, n);
        }
    }  
    if(mcfFile::dbin()) XtSetSensitive(calHitRadioBox, FALSE);
    XtManageChild(calHitRadioBox);
    

//  setup trace box


//  make a frame
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,   XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,       button3); n++;
    XtSetArg(args[n], XmNbottomOffset,   20); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,       calFrame); n++;
    XtSetArg(args[n], XmNleftOffset,   20); n++;
//    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
//    XtSetArg(args[n], XmNrightOffset,   5); n++;
    
    Widget traceFrame = XtVaCreateManagedWidget("traceFrame", 
         xmFrameWidgetClass, form, XmNshadowType, XmSHADOW_ETCHED_OUT, NULL);

    XtSetValues(traceFrame, args, n);

//  make a label
    XmString str1 = XmStringCreate("Trace Plot", 
    XmSTRING_DEFAULT_CHARSET);

    Widget traceLabel = XmCreateLabel(form, "tracelabel", NULL, 0);
    XtVaSetValues(traceLabel, XmNlabelString, str1, NULL);

    n = 0;
    XtSetArg(args[n], XmNbottomAttachment,   XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,   traceFrame); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,  calLabel); n++;
    XtSetArg(args[n], XmNleftOffset,   40); n++;
    XtSetValues(traceLabel, args, n);
    XtManageChild(traceLabel);
    XmStringFree(str1);

    Widget traceRadioBox = XmCreateRadioBox(traceFrame, "traceRadioBox", NULL, 0);

    Widget traceToggles[numTraceType];
    for (i = 0; i < numTraceType; i++)
    {
        traceToggles[i] = XtVaCreateManagedWidget( 
                        PlotNames[(int) traceCbData[i].type] ,  
                        xmToggleButtonGadgetClass, 
                        traceRadioBox, NULL);
        XtAddCallback ( traceToggles[i], XmNvalueChangedCallback, 
                      (XtCallbackProc) tracesCB, 
                      (XtPointer) &traceCbData[i]); 
        
        XtSetSensitive(traceToggles[i], 
                       PlotImplemented[(int) traceCbData[i].type]);
        if( i == numTraceType - 1 )
        {
          XtSetArg(args[n], XmNset, True); n++;
          XtSetValues(traceToggles[i], args, n);
        }
    }  
   
    if(mcfFile::dbin()) XtSetSensitive(traceRadioBox, FALSE);
    XtManageChild(traceRadioBox);
    
//  setup detector box

//  make a frame
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,   XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,       calLabel); n++;
    XtSetArg(args[n], XmNbottomOffset,   20); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,       form); n++;
    XtSetArg(args[n], XmNleftOffset,   30); n++;
    
    Widget detectorFrame = XtVaCreateManagedWidget("detectorFrame", 
         xmFrameWidgetClass, form, XmNshadowType, XmSHADOW_ETCHED_OUT, NULL);

    XtSetValues(detectorFrame, args, n);
      XmString str2 = XmStringCreate("Detector Plot ", 
    XmSTRING_DEFAULT_CHARSET);

    Widget detectorLabel = XmCreateLabel(form, "detectorlabel", NULL, 0);
    XtVaSetValues(detectorLabel, XmNlabelString, str2, NULL);

    n = 0;
    XtSetArg(args[n], XmNbottomAttachment,   XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,   detectorFrame); n++;
    XtSetArg(args[n], XmNbottomOffset,   5); n++;
    XtSetArg(args[n], XmNtopAttachment,   XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNtopOffset,   10); n++;    
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,  form); n++;
    XtSetArg(args[n], XmNleftOffset,   30); n++;
    XtSetValues(detectorLabel, args, n);
    XtManageChild(detectorLabel);
    XmStringFree(str2);

    Widget detectorRadioBox = XmCreateRadioBox(detectorFrame, 
                                "detRadioBox", NULL, 0);

    Widget detectorToggles[numDetectorType];
    for (i = 0; i < numDetectorType; i++)
    {
        detectorToggles[i] = XtVaCreateManagedWidget( 
                        PlotNames[(int) detectorCbData[i].type] ,  
                        xmToggleButtonGadgetClass, 
                        detectorRadioBox, NULL);
        XtAddCallback ( detectorToggles[i], XmNvalueChangedCallback, 
                      (XtCallbackProc) detectorCB, 
                      (XtPointer) &detectorCbData[i]); 
        
        XtSetSensitive(detectorToggles[i], 
                       PlotImplemented[(int) detectorCbData[i].type]);

        if( i == numDetectorType - 1 )
        {
          XtSetArg(args[n], XmNset, True); n++;
          XtSetValues(detectorToggles[i], args, n);
        }
    }
   
    XtManageChild(detectorRadioBox);


//setup up controls for hit plot
    
//  make a frame
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,   XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,       traceLabel); n++;
    XtSetArg(args[n], XmNbottomOffset,   20); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,       detectorFrame); n++;
    XtSetArg(args[n], XmNleftOffset,   20); n++;
    
    Widget hitsFrame = XtVaCreateManagedWidget("hitsFrame", 
         xmFrameWidgetClass, form, XmNshadowType, XmSHADOW_ETCHED_OUT, NULL);

    XtSetValues(hitsFrame, args, n);
    
    str2 = XmStringCreate("Silicon Hits ", XmSTRING_DEFAULT_CHARSET);

    Widget hitsLabel = XmCreateLabel(form, "hitslabel", NULL, 0);
    XtVaSetValues(hitsLabel, XmNlabelString, str2, NULL);

    n = 0;
    XtSetArg(args[n], XmNbottomAttachment,   XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,   hitsFrame); n++;
    XtSetArg(args[n], XmNbottomOffset,   5); n++;
    XtSetArg(args[n], XmNtopAttachment,   XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNtopOffset,   10); n++;    
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,  detectorLabel); n++;
    XtSetArg(args[n], XmNleftOffset,   40); n++;
    XtSetValues(hitsLabel, args, n);
    XtManageChild(hitsLabel);
    XmStringFree(str2);

    Widget hitsRadioBox = XmCreateRadioBox(hitsFrame, 
                                "hitsRadioBox", NULL, 0);

    Widget hitsToggles[numHitsType];
    for (i = 0; i < numHitsType; i++)
    {
        hitsToggles[i] = XtVaCreateManagedWidget( 
                        PlotNames[(int) hitsCbData[i].type] ,  
                        xmToggleButtonGadgetClass, 
                        hitsRadioBox, NULL);
        XtAddCallback ( hitsToggles[i], XmNvalueChangedCallback, 
                      (XtCallbackProc) trackHitsCB, 
                      (XtPointer) &hitsCbData[i]); 
        
        XtSetSensitive(hitsToggles[i], 
                       PlotImplemented[(int) hitsCbData[i].type]);

        if( i == numHitsType - 1 )
        {
          XtSetArg(args[n], XmNset, True); n++;
          XtSetValues(hitsToggles[i], args, n);
        }
    }

    
    XtManageChild(hitsRadioBox);    

    XtManageChild(form);
    XtPopup(XtParent(form),XtGrabNone);    
}
PlotTypes mcfPlotDefine::getPlotType(XtPointer *data,
                                     XmToggleButtonCallbackStruct *call_data)
{
    plotDefineCbData *cbData = (plotDefineCbData *) data;
    XmToggleButtonCallbackStruct *state = call_data;

    if( state->set ) return cbData->type;
    return NOPLOT;
}
void plotDefineCB(Widget, XtPointer *data, XtPointer)
{
//add to the list of plots.  Should probably 
//added some rationality of plot
//combinations at somepoint.

   plotDefineCbData *cbData = (plotDefineCbData *) data;
   
   mcfDisplayList *display = new mcfDisplayList(*(cbData->plotDefine));
   delete cbData->plotDefine; 
    

}

void calHitsCB(Widget, XtPointer *data, 
              XmToggleButtonCallbackStruct *call_data)
{
   plotDefineCbData *cbData = (plotDefineCbData *) data;
   cbData->plotDefine->calHits.type = 
   cbData->plotDefine->getPlotType(data, call_data); return;
}
void tracesCB(Widget, XtPointer *data, 
              XmToggleButtonCallbackStruct *call_data)
{
   plotDefineCbData *cbData = (plotDefineCbData *) data;
   cbData->plotDefine->traces.type = 
   cbData->plotDefine->getPlotType(data, call_data); return;
}
void trackHitsCB(Widget, XtPointer *data, 
                 XmToggleButtonCallbackStruct *call_data)
{
   plotDefineCbData *cbData = (plotDefineCbData *) data;
   cbData->plotDefine->trackHits.type = 
   cbData->plotDefine->getPlotType(data, call_data); return;
}
void detectorCB(Widget, XtPointer *data, 
                        XmToggleButtonCallbackStruct *call_data)
{
   plotDefineCbData *cbData = (plotDefineCbData *) data;
   cbData->plotDefine->detector.type = 
                 cbData->plotDefine->getPlotType(data, call_data); return;
}
void ivDefineCB(Widget, XtPointer *data, 
                           XmToggleButtonCallbackStruct *call_data)
{
   plotDefineCbData *cbData = (plotDefineCbData *) data;
   cbData->plotDefine->ivFile.type = 
                 cbData->plotDefine->getPlotType(data, call_data); return;
}
void vertexCB(Widget, XtPointer *data, 
              XmToggleButtonCallbackStruct *call_data)
{
   plotDefineCbData *cbData = (plotDefineCbData *) data;
   cbData->plotDefine->vertex.type = 
               cbData->plotDefine->getPlotType(data, call_data); return;
}

     
