#include "mcfPlotModify.hh"
#include "mcfTraceModifyWindow.hh"
#include "mcfDetectorModifyWindow.hh"
extern "C" {
#include "DialogF.h"
}
//need to find MAX_ARG in nirvana stuff?
const int MAX_ARG = 20;

void mcfPlotModify::displayPlotModifyDialog(Widget parent, mcfPlotWindow *win)
{
    Arg args[MAX_ARG]; int n = 0;
    int i;
    Widget form = XmCreateFormDialog(parent, "PlotModifyForm", args, n);   
    XtVaSetValues(form, XmNwidth, 350, XmNheight, 200, NULL);
    
    //setup callback data
    cbData = new plotModifyCbData[PLOT_CATAGORY_ALL];
    for(i = 0; i < PLOT_CATAGORY_ALL; i++)
    {
       (cbData + i) -> plot = win;
       (cbData + i) -> type = (PlotCatagory) i;
       (cbData + i) -> panel = this;
    }
    
 //  setup modify box

    XmString str = XmStringCreate("Select type to Modify", 
    XmSTRING_DEFAULT_CHARSET);

    Widget Label = XmCreateLabel(form, "plotModifyLabel", NULL, 0);
    XtVaSetValues(Label, XmNlabelString, str);

    n = 0;
    XtSetArg(args[n], XmNtopAttachment,   XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNtopOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   5); n++;
    XtSetValues(Label, args, n);
    XtManageChild(Label);
    XmStringFree(str);

    Widget RadioBox = XmCreateRadioBox(form, "ModifyRadioBox", NULL, 0);

    Widget Toggles[PLOT_CATAGORY_ALL];
    for (i = 0; i < PLOT_CATAGORY_ALL; i++)
    {
        Toggles[i] = XtVaCreateManagedWidget( 
                        CatagoryNames[(int) cbData[i].type] ,  
                        xmToggleButtonGadgetClass, 
                        RadioBox, NULL);
        XtAddCallback ( Toggles[i], XmNvalueChangedCallback, 
                      (XtCallbackProc) plotModifyCB, 
                      (XtPointer) &cbData[i]); 
        
    }  
    XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNtopOffset,   5); n++;
    XtSetArg(args[n], XmNtopWidget,  Label); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   10); n++;
    XtSetValues(RadioBox, args, n); 
    XtManageChild(RadioBox);
   

    XmString string1 = XmStringCreateSimple("Dismiss");
    n = 0;
    XtSetArg(args[n], XmNlabelString, string1 ); n++;
    XtSetArg(args[n], XmNtopAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNtopWidget,  RadioBox); n++;
    XtSetArg(args[n], XmNtopOffset,   15); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   40); n++;
    //XtSetArg(args[n], XmNbottomAttachment,  XmATTACH_FORM); n++;
    Widget button1 = XmCreatePushButton(form, "dismissM", args, n);
    XtAddCallback ( button1, XmNactivateCallback, 
                  (XtCallbackProc) dismissCB, 
                  (XtPointer) &cbData[0]); 
    XtManageChild(button1);
    XmStringFree(string1);
    
   
    XtManageChild(form);
    XtPopup(XtParent(form),XtGrabNone);    

}


void plotModifyCB(Widget, XtPointer *data, XtPointer call_data)
{
       plotModifyCbData *cbData = (plotModifyCbData *) data;
       XmToggleButtonCallbackStruct *state = 
                        ( XmToggleButtonCallbackStruct *) call_data;
       if(state->set)
       {
	   switch( cbData->type )
	   {

	   case CALHIT:
              break;
	   case TRACEDISP:
              mcfTraceModifyWindow *traceWindow = 
                        	   new mcfTraceModifyWindow(cbData->plot);
              break;
	   case DETECTOR:
	      mcfDetectorModifyWindow *detectorWindow =
	                           new mcfDetectorModifyWindow(cbData->plot);
              break;

	   }
       }

}
void dismissCB(Widget, XtPointer *data, XtPointer)
{
       plotModifyCbData *cbData = (plotModifyCbData *) data;
       delete cbData->panel;
}
