#include <stdio.h>
#include <ctype.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include <Inventor/Xt/viewers/SoXtExaminerViewer.h>
#include <Inventor/Xt/SoXtMaterialEditor.h>
#include <Xm/RowColumn.h>
#include <Xm/Separator.h>
#include <Xm/Scale.h>
#include <Xm/Text.h>
#include <Xm/TextF.h>
#include <Xm/ScrollBar.h>
#include <Xm/ScrolledW.h>
#include <Xm/Frame.h>
#include "tree.h"
#include "McFDetectorTreeList.hh"
#include "mcfDisplayList.hh"
#include "ivButton.hh"
#include "mcfDetectorModifyWindow.hh"
#include "misc.h"
extern "C" {
#include "DialogF.h"
}

//color editor defintion
static SoXtMaterialEditor *colorEditor = NULL;

Widget mcfDetectorModifyWindow::scrollTree = NULL;  //scrolled window to hold tree
Widget mcfDetectorModifyWindow::treeWidget = NULL;  //the tree widget

enum plotCalModifyMenuEntries {
    DW_HELP,
    DW_HELP_OVERALL,

    DW_MENU_NUM		// this must be the last entry
};

const int treeHeight = 400;
const int treeWidth = 400;

mcfDetectorModifyWindow::~mcfDetectorModifyWindow(void)
{
    delete [] cbData;
}
void mcfDetectorModifyWindow::makeMcfWindow(Widget main)
{

// define the buttons and the pulldowns
static ivButton buttonData[] = {
   {"About...", DW_HELP_OVERALL,  IV_PUSH_BUTTON, "", ""}
};
static ivMenu pulldownData[] = {
// {name, id, subMenu, subItemCount}
   {"Help",  DW_HELP, buttonData, 1 }
};
static togNames geoStyle[3] =
{
      "Solid",
      "Wireframe",
      "Invisible"
};
static togNames geoRep[3] =
{
      "More Detail",
      "Less Detail",
      "Not Shown"
};
static togNames geoSel[3] =
{
      "Children",
      "Sisters",
      "Self"
};
int set[3];
for (int i = 0; i<3; i++) set[i] = 0;
//allocate and fill structure for callback
cbData = new toggleButtonCbData[3];
for( i = 0; i < 3; i++ )
{
    cbData[i].window = this;
    cbData[i].setting = i;
}     
// Now do the work
     Shell = MakeDetachedShell(main,"Detector Modify");
     form = MakeForm(Shell, 600, 750);
     int n = 0;
     Arg args[10];
     XtSetArg(args[n], XmNautoUnmanage,  False); n++;
     XtSetValues(form, args, n);

     
     Widget menuWidget = buildAndLayoutMenu(form, pulldownData,
                                                  XtNumber( pulldownData ),
                                                  (XtCallbackProc) 
                                                  plotDetModifyMenuCB);

// set up buttons for action

    Widget ok = MakeDialogButton(form, "Ok     ", 
    (XtCallbackProc)plotDetOkCB,
    (XtPointer *) this, form, 175);  

    Widget apply = MakeDialogButton(form, "Apply  ", 
    (XtCallbackProc)plotDetApplyCB,
    (XtPointer *) this, ok, 20);  

    Widget dimiss = MakeDialogButton(form, "Dismiss", 
    (XtCallbackProc)plotDetDismissCB,
    (XtPointer *) this, apply, 20);  


//add radio buttons
    char string[50];
    XmString str;
    Widget RadioBox;
    
//make frames to hold radio buttons for the style and reps.

    n=0;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        ok); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   10); n++;
    XtSetArg(args[n], XmNshadowType, XmSHADOW_ETCHED_IN); n++;
    Widget frame1 = XmCreateFrame(form, "Frame1", args, n);
 
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        ok); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,        frame1); n++;
    XtSetArg(args[n], XmNleftOffset,   10); n++;
    XtSetArg(args[n], XmNshadowType, XmSHADOW_ETCHED_IN); n++;
    Widget frame2 = XmCreateFrame(form, "Frame2", args, n);
    

//label for style  of the objects
    sprintf(string, "%s", "Set Style");
    str = XmStringCreate(string,XmSTRING_DEFAULT_CHARSET); 
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        frame1); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   22); n++;
    Widget Label1 = XmCreateLabel(form, string, args, n);
    XtVaSetValues(Label1, XmNlabelString, str, NULL);
    XtManageChild(Label1);
    XmStringFree(str);

//label for the representation  
    sprintf(string, "%s", "Set Detail Level");
    str = XmStringCreate(string,XmSTRING_DEFAULT_CHARSET); 
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        frame2); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftOffset,   35); n++;
    XtSetArg(args[n], XmNleftWidget,        Label1); n++;
    Widget Label2 = XmCreateLabel(form, string, args, n);
    XtVaSetValues(Label2, XmNlabelString, str, NULL);
    XtManageChild(Label2);
    XmStringFree(str);
//The style  of the objects
    set[0] = 0;
    RadioBox = BuildRadioBox(frame1,"geoStyle", 
                                 3, geoStyle, set,
                                 (XtCallbackProc) 
                                 McFDetectorTreeList::StyleModifyCB, 
                                 cbData); 
    XtManageChild(RadioBox);

    
//The representation  
     RadioBox = BuildRadioBox(frame2,"geoRep", 
                                 3, geoRep, set,
                                 (XtCallbackProc) 
                                 McFDetectorTreeList::RepModifyCB, 
                                 cbData); 
    XtManageChild(RadioBox);


// add a rowcolumn widget to hold buttons
   Widget rowColBut = XtVaCreateWidget("RowColBut",
                     xmRowColumnWidgetClass, form,
                     XmNorientation, XmVERTICAL,
                     XmNpacking, XmPACK_COLUMN,
                     XmNnumColumns, 1,
                     NULL);
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        ok); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,  frame2); n++;
    XtSetArg(args[n], XmNleftOffset,   10); n++;
//    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_WIDGET); n++;
//    XtSetArg(args[n], XmNrightWidget,  form); n++;
    XtSetArg(args[n], XmNrightOffset,   10); n++;
    XtSetValues(rowColBut, args, n);
//    SetTopShellColors(rowColBut);
//Pop up material Editor

    XmString buttonStr = XmStringCreateSimple("Material Editor");
    n = 0;
    XtSetArg(args[n], XmNlabelString, buttonStr ); n++;
    Widget button = XmCreatePushButton(rowColBut, "MatEditor", args, n);
    XtAddCallback ( button, XmNactivateCallback, 
                  (XtCallbackProc)
                  mcfDetectorModifyWindow::ColorEditorCB, 
                  NULL ); 
    XtManageChild(button);
    XmStringFree(buttonStr);
    
    if(colorEditor == NULL) colorEditor = new SoXtMaterialEditor;
    colorEditor->addMaterialChangedCallback
                            (McFDetectorTreeList::MaterialEditorCB,
                             NULL);

//Cut open cylinders

    buttonStr = XmStringCreateSimple("Cut Cylinders");

    n = 0;
    XtSetArg(args[n], XmNlabelString, buttonStr ); n++;
    button = XmCreatePushButton(rowColBut, "CutCyl", args, n);
//    XtAddCallback ( button, XmNactivateCallback, 
//                  (XtCallbackProc) , 
//                  (XtPointer) this ); 
    XtManageChild(button);
    XmStringFree(buttonStr);
    XtSetSensitive(button, False); //not implemented yet.



//label for instructions
    sprintf
    (string, "%s", "To modify display, select icons and change settings");
    str = XmStringCreate(string,XmSTRING_DEFAULT_CHARSET); 
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        Label1); n++;
    XtSetArg(args[n], XmNbottomOffset,   5); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   3); n++;
    Widget LabelM = XmCreateLabel(form, string, args, n);
    XtVaSetValues(LabelM, XmNlabelString, str, NULL);
    XtManageChild(LabelM);
    XmStringFree(str);

//scroll widget to hold the text
//    n = 0;
//    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
//   XtSetArg(args[n], XmNbottomWidget,        LabelM); n++;
//    XtSetArg(args[n], XmNleftAttachment,   XmATTACH_FORM); n++;
//    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
//    XtSetArg(args[n], XmNbottomOffset,        5); n++;
//    XtSetArg(args[n], XmNscrollBarDisplayPolicy,  XmAS_NEEDED); n++;
//    XtSetArg(args[n], XmNscrollingPolicy,  XmAUTOMATIC); n++;
//    XtSetArg(args[n], XmNorientation,  XmVERTICAL); n++;
//    XtSetArg(args[n], XmNprocessingDirection,  XmMAX_ON_TOP); n++;
//    XtSetArg(args[n], XmNeditMode, XmMULTI_LINE_EDIT); n++;
//    XtSetArg(args[n], XmNwidth, 400); n++;
//    XtSetArg(args[n], XmNheight, 100); n++;
 
//    XtSetArg(args[n], XmNdeleteResponse, XmDO_NOTHING); n++;
//    _scrollInfo = XmCreateScrolledText(form, "ScrollInfo", args, n);
//    _scrollInfo = XmCreateText(form, "ScrollInfo", args, n);
//    XtManageChild( _scrollInfo );


//label for info instructions
    sprintf
    (string, "%s", 
    "Press Right Mouse button over Icon For Detector Definition");
    str = XmStringCreate(string,XmSTRING_DEFAULT_CHARSET); 
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        LabelM); n++;
    XtSetArg(args[n], XmNbottomOffset,   5); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   3); n++;
//    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
    Widget LabelI = XmCreateLabel(form, "Right", args, n);
    XtVaSetValues(LabelI, XmNlabelString, str, NULL);
    XtManageChild(LabelI);
    XmStringFree(str);


//scroll widget to hold the tree
    n = 0;
    XtSetArg(args[n], XmNscrollBarDisplayPolicy,  XmAS_NEEDED); n++;
    XtSetArg(args[n], XmNscrollingPolicy, XmAUTOMATIC); n++;
    XtSetArg(args[n], XmNwidth, treeWidth); n++;
    XtSetArg(args[n], XmNheight, treeHeight); n++;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        LabelI); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   10); n++;
    scrollTree = XtCreateManagedWidget("scrolltree",
                    xmScrolledWindowWidgetClass, form, args, n);
//  make the tree itself
    
    treeWidget=BuildTreeWidget(scrollTree, "mytree", 0,
                                treeWidth, treeHeight);
    McFDetectorTreeList::MakeTree(treeWidget);


//label for Tree
    sprintf
    (string, "%s", "Detector Hierachy:");
    str = XmStringCreate(string,XmSTRING_DEFAULT_CHARSET); 
    n=0;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        scrollTree); n++;
    XtSetArg(args[n], XmNbottomOffset,   2); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   3); n++;
    Widget LabelT = XmCreateLabel(form, "DetectorDef", args, n);
    XtVaSetValues(LabelT, XmNlabelString, str, NULL);
    XtManageChild(LabelT);
    XmStringFree(str);


    sprintf(string, "%s", "Selection Policy:");
    str = XmStringCreate(string,XmSTRING_DEFAULT_CHARSET);
    n=0;
    XtSetArg(args[n], XmNtopAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNtopWidget,        menuWidget); n++;
    XtSetArg(args[n], XmNtopOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftOffset,   3); n++;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        LabelT); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    Widget Label0 = XmCreateLabel(form, "SelectionP", args, n);
    XtVaSetValues(Label0, XmNlabelString, str, NULL);
    XtManageChild(Label0);
    XmStringFree(str);
    


//make frame to hold radio buttons for selection
    n=0;
//    XtSetArg(args[n], XmNtopAttachment,    XmATTACH_WIDGET); n++;
//    XtSetArg(args[n], XmNtopWidget,        menuWidget); n++;
//    XtSetArg(args[n], XmNtopOffset,   10); n++;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        LabelT); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,        Label0); n++;
    XtSetArg(args[n], XmNleftOffset,   10); n++;
    XtSetArg(args[n], XmNshadowType, XmSHADOW_ETCHED_IN); n++;
    Widget frame0 = XmCreateFrame(form, "Frame0", args, n);

    
//the selection policy
    set[0] = 1;
    RadioBox = BuildRadioBox(frame0,"geoSel", 
                                3, geoSel, set,
                                (XtCallbackProc) 
                                McFDetectorTreeList::selectPolicyCB, 
                                cbData); 
    n=0;
    XtSetArg(args[n], XmNpacking,    XmPACK_COLUMN); n++;
    XtSetArg(args[n], XmNnumColumns,    1); n++;
    XtSetArg(args[n], XmNorientation, XmHORIZONTAL); n++;
    XtSetValues(RadioBox, args, n);
 

    XtManageChild(RadioBox);



    
//Deselect all

    buttonStr = XmStringCreateSimple("Deselect All");

    n = 0;
    XtSetArg(args[n], XmNlabelString, buttonStr ); n++;
//    XtSetArg(args[n], XmNtopAttachment,    XmATTACH_WIDGET); n++;
//    XtSetArg(args[n], XmNtopWidget,        menuWidget); n++;
//    XtSetArg(args[n], XmNtopOffset,   10); n++;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        LabelT); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,        frame0); n++;
    XtSetArg(args[n], XmNleftOffset,   10); n++;
    
    button = XmCreatePushButton(form, "Deselect", args, n);
    XtAddCallback ( button, XmNactivateCallback, 
                  (XtCallbackProc) McFDetectorTreeList::DeselectAll, 
                  NULL ); 
    XtManageChild(button);
    XmStringFree(buttonStr);


    
    XtManageChild(frame0); 
    XtManageChild(frame1); 
    XtManageChild(frame2);
    XtManageChild(rowColBut);
    XtManageChild(form);
    XtRealizeWidget(Shell); 

    return;
      
   
}
void mcfDetectorModifyWindow::remakeTree(void)
{
    Widget scrollbar;
    int height, width; 
    int pos,size,incr,page;

    int n = 0;
    Arg args[10];
    
    XtSetArg(args[n], XmNverticalScrollBar, &scrollbar); n++;
    XtSetArg(args[n], XmNheight, &height); n++;
    XtSetArg(args[n], XmNwidth, &width); n++;
    XtGetValues(scrollTree, args, n);
    XmScrollBarGetValues(scrollbar,&pos,&size,&incr,&page);

    if(treeWidget != NULL)XtDestroyWidget(treeWidget);
    
    XtSetArg(args[n], XmNautoUnmanage, TRUE); n++;
    XtSetArg(args[n], XmNborderWidth, 0); n++;
    XtSetArg(args[n], XmNwidth, treeWidth); n++;
    XtSetArg(args[n], XmNheight, treeHeight); n++;
        
    treeWidget = XtCreateManagedWidget("mytree",
                XstreeWidgetClass, scrollTree, args, n);
    McFDetectorTreeList::MakeTree(treeWidget);
    XmScrollBarSetValues(scrollbar,pos,size,incr,page,True);
    
}
static void plotDetModifyMenuCB( Widget, XtPointer *data, XtPointer *)
{
    ivMenuItem *menudata = (ivMenuItem *) data;
    mcfDetectorModifyWindow *win = (mcfDetectorModifyWindow *)menudata->mcfWin;
    mcfPlotWindow *plot = win->GetPlot(); 
    switch (menudata->id) {


    case DW_HELP_OVERALL:
      DialogF(DF_INF, plot->getShell(), 1,
      "This panel allows you to modify parameters\n for the detector",
	    "OK"); 
       break;

    }
    
}
static void plotDetApplyCB( Widget, XtPointer *data, XtPointer *)
{
      mcfDetectorModifyWindow *window = (mcfDetectorModifyWindow *) data;
      mcfPlotWindow *plot = window->GetPlot();
      
      //nothing to apply at this point
      return;
      
}
static void plotDetOkCB( Widget, XtPointer *data, XtPointer *)
{
      mcfDetectorModifyWindow *window = (mcfDetectorModifyWindow *) data;
      mcfPlotWindow *plot = window->GetPlot();
      
      //nothing to apply at this point
      
      XtDestroyWidget(XtParent(window->getForm()));
      delete window;
      return;
      
}
static void plotDetDismissCB( Widget, XtPointer *data, XtPointer *)
{
      mcfDetectorModifyWindow *window = (mcfDetectorModifyWindow *) data;
      XtDestroyWidget(XtParent(window->getForm()));
      delete window;
      return;
      
}
void mcfDetectorModifyWindow::ColorEditorCB( Widget, XtPointer *,
                                             XtPointer *)
{
     if(colorEditor != NULL) colorEditor->show();
    
}
