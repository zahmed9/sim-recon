#define APP_NAME "McfIV"
#define APP_CLASS "McfIV"
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include <Inventor/Xt/viewers/SoXtFullViewer.h>
#include <Inventor/Xt/viewers/SoXtFlyViewer.h>
#include <Inventor/Xt/viewers/SoXtPlaneViewer.h>
#include <Inventor/Xt/viewers/SoXtWalkViewer.h>
#include "mcfWindow.hh"
#include <X11/Intrinsic.h>
extern "C" {
#include "DialogF.h"
#include "tree.h"
}
#include <Xm/Scale.h>
#include <Xm/ScrolledW.h>

Widget mcfWindow::buildAndLayoutMenu (Widget parent, ivMenu *pulldownData,
                                         int numMenu,
                                         XtCallbackProc theCallbackProc)
{
//local variables
  WidgetClass myWidgetClass;
//find the total amount of stuff
  int numItems = numMenu;

  for(int i = 0; i < numMenu; i++)
  {
      numItems += (pulldownData+i)->subItemCount;
  }

  this->menuItems = new ivMenuItem[numItems];
  
  Widget menuWidget = XmCreateMenuBar(parent, "menuBar", NULL, 0);
  Arg popupargs[4];
  int popupn = 0;
  Widget shell = SoXt::getShellWidget(menuWidget);
  SoXt::getPopupArgs(XtDisplay(menuWidget), NULL, popupargs, &popupn);
  WidgetList buttons = (WidgetList) XtMalloc(numMenu * sizeof(Widget));
    Arg args[12];
    int n;
    for (i=0; i<numMenu; i++)
    {

	//
        // Make Topbar menu button
	//

        Widget subMenu = 
		XmCreatePulldownMenu(menuWidget, NULL, popupargs, popupn);

	// register callbacks to load/unload the pulldown colormap when the
	// pulldown menu is posted.
	SoXt::registerColormapLoad(subMenu, shell);
	
        int id = pulldownData[i].id;
        menuItems[id].widget = subMenu;

        XtSetArg(args[0], XmNsubMenuId, subMenu);
        buttons[i] = XtCreateWidget(pulldownData[i].name,
            		xmCascadeButtonGadgetClass, menuWidget, args, 1);

        if( strcmp(pulldownData[i].name, "Help") == 0 )
           XtVaSetValues (menuWidget, XmNmenuHelpWidget, buttons[i], NULL);

	//
        // Make subMenu buttons
	//

        int subItemCount = pulldownData[i].subItemCount;
        WidgetList subButtons = 
		(WidgetList) XtMalloc(subItemCount * sizeof(Widget));

        for (int j=0; j<subItemCount; j++) {
            if (pulldownData[i].subMenu[j].buttonType == IV_SEPARATOR) {
                subButtons[j] = XtCreateWidget(
			NULL, xmSeparatorGadgetClass, subMenu, NULL, 0);
  	    }
            else {
		String callbackReason;

                switch (pulldownData[i].subMenu[j].buttonType) {
                    case IV_PUSH_BUTTON:
                        myWidgetClass = xmPushButtonGadgetClass;
                        callbackReason = XmNactivateCallback;
                        n = 0;
                        break;
                    case IV_TOGGLE_BUTTON:
                        myWidgetClass = xmToggleButtonGadgetClass;
                        callbackReason = XmNvalueChangedCallback;
                        n = 0;
                        break;
                    case IV_RADIO_BUTTON:
                        myWidgetClass = xmToggleButtonGadgetClass;
                        callbackReason = XmNvalueChangedCallback;
                        XtSetArg(args[0], XmNindicatorType, XmONE_OF_MANY);
                        n = 1;
                        break;
                    default:
                        fprintf(stderr, 
				"ivview INTERNAL ERROR: bad buttonType\n");
                        break;
                }

		//
                // Check for keyboard accelerator
		//

                char *accel = pulldownData[i].subMenu[j].accelerator;
                char *accelText = pulldownData[i].subMenu[j].accelText;
                XmString xmstr = NULL;
                if (accel != NULL) {
                    XtSetArg(args[n], XmNaccelerator, accel); n++;

                    if (accelText != NULL) {
                        xmstr = XmStringCreate(accelText,
                                         XmSTRING_DEFAULT_CHARSET);
                        XtSetArg(args[n], XmNacceleratorText, xmstr); n++;
                    }
                }

                subButtons[j] = XtCreateWidget(
					pulldownData[i].subMenu[j].name,
                    			myWidgetClass, subMenu, args, n);
                if (xmstr != NULL)
                    XmStringFree(xmstr);
                id = pulldownData[i].subMenu[j].id;
                menuItems[id].mcfWin = this;
                menuItems[id].widget = subButtons[j];
                menuItems[id].id = id;
                XtAddCallback(subButtons[j], callbackReason,
                    (XtCallbackProc) theCallbackProc,
                    ( XtPointer )&menuItems[id]);

                //XtSetSensitive(menuItems[id].widget,
                //pulldownData[i].subMenu[j].OnAtInitalize);
            }
        }
        XtManageChildren(subButtons, subItemCount);
        XtFree((char *)subButtons);

    }
    XtManageChildren(buttons, numMenu);
    XtFree((char *)buttons);
    n = 0;
    XtSetArg(args[n], XmNtopAttachment,   XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNrightAttachment, XmATTACH_FORM); n++;
    XtSetValues(menuWidget, args, n);
    XtManageChild(menuWidget);
    
    //SetTopShellColors(menuWidget);
    return (menuWidget);

}
SoXtViewer *mcfWindow::buildAndLayoutViewer(Widget parent, 
                                               Widget menuWidget)
{
    SoXtViewer *viewer = ( SoXtViewer *)
        buildAndLayoutViewer(parent, menuWidget, VIEWER);    
    viewer->setViewing(TRUE);	// default to VIEW
    return (viewer);
}
SoXtRenderArea *mcfWindow::buildAndLayoutViewer(Widget parent, 
                                               Widget menuWidget, 
                                               renderType type)
{
    Arg args[12];
    int n = 0;
    SoXtRenderArea *viewer;
    if( type == VIEWER )
    {
       viewer = new SoXtExaminerViewer(parent);
    }
    else if( type == RENDER )
    {
       viewer = new SoXtRenderArea(parent); 
    }
    else if( type == WALK )
    {
       viewer = new SoXtWalkViewer(parent); 
    }
    else if( type == FLY )
    {
       viewer = new SoXtFlyViewer(parent); 
    }
    else if( type == PLANE )
    {
       viewer = new SoXtPlaneViewer(parent); 
    }
    
    XtSetArg(args[n], XmNtopAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNtopWidget,        menuWidget); n++;
    XtSetArg(args[n], XmNbottomAttachment, XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftAttachment,   XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
    XtSetValues(viewer->getWidget(), args, n);
    
    return (viewer);
}

Widget mcfWindow::MakeForm(Widget parent, int width, int height)
{
    Widget form = XtCreateWidget("Form", 
         xmFormWidgetClass, parent, NULL, 0);

    XtVaSetValues(parent, XmNwidth, width, XmNheight, height, NULL);
    //SetTopShellColors(XtParent(form));
    //SetTopShellColors(form);
    return form;
}

Widget mcfWindow::MakeFormDialog(Widget parent, int width, int height,
                                 char *name)
{
    Widget form = XmCreateFormDialog(parent, name, NULL, 0);   
    XtVaSetValues(form, XmNwidth, width, XmNheight, height, NULL);
    //SetTopShellColors(XtParent(form));
    //SetTopShellColors(form);
    return form;
}

Widget mcfWindow::MakeDialogButton(Widget parent, char *name, 
                                   XtCallbackProc theCallbackProc,
                                   XtPointer *Data,
                                   Widget leftAttach, 
                                   int leftOffset)
{
    XmString string = XmStringCreateSimple(name);

    int n = 0;
    Arg args[10];
    XtSetArg(args[n], XmNlabelString, string ); n++;
    XtSetArg(args[n], XmNbottomAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,  leftAttach); n++;
    XtSetArg(args[n], XmNleftOffset,   leftOffset); n++;
    XtSetArg(args[n], XmNbottomOffset,   10); n++;
    Widget button = XmCreatePushButton(parent, name, args, n);
    XtAddCallback ( button, XmNactivateCallback, 
                  (XtCallbackProc) theCallbackProc, 
                  (XtPointer) Data ); 
    XtManageChild(button);
    XmStringFree(string);
    return button;
    
}

Widget mcfWindow::MakeDetachedShell(Widget parent, char *name)
{
 
   Widget shell = XtVaAppCreateShell ("Inventor", "Inventor",
	     topLevelShellWidgetClass, SoXt::getDisplay(),
	     XmNtitle, name,
	     XmNiconName, name,
	     XmNallowShellResize, False, 0);
	     
   //SetTopShellColors(shell);
   return shell;
}
Widget mcfWindow::BuildAndLayoutScrolledText(Widget parent, 
                                     Widget topAttach,
                                     Widget bottomAttach,
                                     int topOffset,
                                     int bottomOffset,
                                     char *name)
//to make the window grow properly, it needs to have its bottom and top
//attached to something.  And I want its sides attached to the form
{
    Arg args[20];
    int n = 0;
    
    XtSetArg(args[n], XmNtopAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNtopWidget,        topAttach); n++;
    XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNbottomWidget,        bottomAttach); n++;
    XtSetArg(args[n], XmNleftAttachment,   XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNtopOffset,        topOffset); n++;
    XtSetArg(args[n], XmNbottomOffset,        bottomOffset); n++;
    XtSetArg(args[n], XmNscrollBarDisplayPolicy,  XmAS_NEEDED); n++;
    XtSetArg(args[n], XmNscrollingPolicy,  XmAUTOMATIC); n++;
    XtSetArg(args[n], XmNorientation,  XmVERTICAL); n++;
    XtSetArg(args[n], XmNprocessingDirection,  XmMAX_ON_TOP); n++;
    XtSetArg(args[n], XmNeditMode, XmMULTI_LINE_EDIT); n++;

    XtSetArg(args[n], XmNdeleteResponse, XmDO_NOTHING); n++;
    Widget text = XmCreateScrolledText(parent, name, args, n);
    XtManageChild( text );
    return (text);

};
Widget mcfWindow::BuildAndLayoutText(Widget parent, Widget menuWidget )
{
    Arg args[12];
    int n = 0;
    Widget text = XmCreateText(parent, "Text", NULL, 0);
    
    XtSetArg(args[n], XmNtopAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNtopWidget,        menuWidget); n++;
    XtSetArg(args[n], XmNbottomAttachment, XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNleftAttachment,   XmATTACH_FORM); n++;
    XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
    XtSetValues(text, args, n);
    XtManageChild( text );
    return (text);

};
Widget mcfWindow::MakeScale(Widget parent, char *name, int min, int max,
                         int value, int decPoint)
{
       Widget Scale = XtVaCreateManagedWidget(name,
                      xmScaleWidgetClass, parent,
                      XtVaTypedArg, XmNtitleString, XmRString,
                      name, strlen(name), 
                      XmNmaximum, max,
                      XmNminimum, min,
                      XmNdecimalPoints, decPoint,
                      XmNvalue, value,
                      XmNorientation, XmHORIZONTAL,
                      XmNprocessingDirection, XmMAX_ON_RIGHT,
                      XmNshowValue, True, NULL);
        return Scale;
}
Widget mcfWindow::BuildAndLayoutRowCol(Widget parent, char *name,
                                       Widget topAttach,
                                       Widget leftAttach, int topOffset,
                                       int leftOffset, int ncol)
{
    Arg args[12];
    int n = 0;
      Widget rowCol = XtVaCreateWidget(name,
                     xmRowColumnWidgetClass, parent,
                     XmNorientation, XmHORIZONTAL,
                     XmNpacking, XmPACK_COLUMN,
                     XmNnumColumns, ncol,
                     NULL);
    
    XtSetArg(args[n], XmNtopAttachment,    XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNtopWidget,        topAttach); n++;
    XtSetArg(args[n], XmNtopOffset,   topOffset); n++;
    XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
    XtSetArg(args[n], XmNleftWidget,  leftAttach); n++;
    XtSetArg(args[n], XmNleftOffset,   leftOffset); n++;
    XtSetValues(rowCol, args, n);
    SetTopShellColors(rowCol);
    return (rowCol);

};
Widget mcfWindow::BuildRadioBox(Widget parent, char *name, int nToggles,
                                togNames *togNames, int *set,
                                XtCallbackProc theCallbackProc,
                                toggleButtonCbData *cbData)
{
    Widget RadioBox = XmCreateRadioBox(parent, name, NULL, 0);
    Widget Toggles;

    for (int i = 0; i < nToggles; i++)
    {
	Toggles = XtVaCreateManagedWidget( 
                	togNames[i].nameTog ,  
                	xmToggleButtonGadgetClass, 
                	RadioBox, NULL);
	XtAddCallback ( Toggles, XmNvalueChangedCallback, 
                       theCallbackProc, 
                       (XtPointer *) (cbData+i)); //cast has higher precedence
                                                  // than addition! 

        if(set[i] == 1)
        {
           int n =0;  Arg args[3];
           XtSetArg(args[n], XmNset,  True); n++;
           XtSetValues(Toggles, args, n);
        }
    } 
    return RadioBox; 
 

}
Widget mcfWindow::BuildScrolledWidget(Widget parent, char *name, 
                                   int width, int height, 
                                   Widget topAttach,
                                   Widget bottomAttach,
                                   Widget leftAttach,
                                   Widget rightAttach,
                                   int topOffset, int bottomOffset,
                                   int leftOffset, int rightOffset)
{
        int n = 0; Arg args[30];
        XtSetArg(args[n], XmNscrollBarDisplayPolicy,  XmAS_NEEDED); n++;
        XtSetArg(args[n], XmNscrollingPolicy, XmAUTOMATIC); n++;
        XtSetArg(args[n], XmNwidth, width); n++;
        XtSetArg(args[n], XmNheight, height); n++;
	XtSetArg(args[n], XmNtopAttachment,    XmATTACH_WIDGET); n++;
	XtSetArg(args[n], XmNtopWidget,        topAttach); n++;
	XtSetArg(args[n], XmNtopOffset,   topOffset); n++;
	XtSetArg(args[n], XmNbottomAttachment,    XmATTACH_WIDGET); n++;
	XtSetArg(args[n], XmNbottomWidget,        bottomAttach); n++;
	XtSetArg(args[n], XmNbottomOffset,   bottomOffset); n++;
	XtSetArg(args[n], XmNleftAttachment,  XmATTACH_WIDGET); n++;
	XtSetArg(args[n], XmNleftWidget,  leftAttach); n++;
	XtSetArg(args[n], XmNleftOffset,   leftOffset); n++;
	XtSetArg(args[n], XmNrightAttachment,    XmATTACH_WIDGET); n++;
	XtSetArg(args[n], XmNrightWidget,        rightAttach); n++;
	XtSetArg(args[n], XmNrightOffset,   rightOffset); n++;
        
        return (XtCreateManagedWidget(name,
                    xmScrolledWindowWidgetClass, parent, args, n));
             

}
Widget mcfWindow::BuildTreeWidget(Widget parent, char *name, int borderWidth,
                               int width, int height)
{
        int n = 0; Arg args[10];
        XtSetArg(args[n], XmNautoUnmanage, TRUE); n++;
        XtSetArg(args[n], XmNborderWidth, borderWidth); n++;
        XtSetArg(args[n], XmNwidth, width); n++;
        XtSetArg(args[n], XmNheight, height); n++;
        
        return (XtCreateManagedWidget(name,
                    XstreeWidgetClass, parent, args, n));

}
void mcfWindow::SetTopShellColors(Widget topShell)
{
    Pixel bottomShadow;
    Pixel topShadow;
    Pixel highlight;
    Pixel borderColor;
    Pixel foreground;
    Pixel background;
    Widget main = SoXt::getTopLevelWidget();
    XtVaGetValues(main, XmNbottomShadowColor, &bottomShadow,
                        XmNtopShadowColor, &topShadow,
                        XmNhighlightColor, &highlight,
                        XmNborderColor, &borderColor,
                        XmNforeground, &foreground,
                        XmNbackground, &background, NULL);
    XtVaSetValues(topShell, XmNbottomShadowColor, bottomShadow,
                        XmNtopShadowColor, topShadow,
                        XmNhighlightColor, highlight,
                        XmNborderColor, borderColor,
                        XmNforeground, foreground,
                        XmNbackground, background, NULL);
    return;
    
}
void mcfWindow::changeTitle(Widget shell, char *title)
{
    int n = 0; Arg args[1];
    XtSetArg(args[n], XmNtitle, title); n++;
    XtSetValues(shell, args, n);
    return;
}
