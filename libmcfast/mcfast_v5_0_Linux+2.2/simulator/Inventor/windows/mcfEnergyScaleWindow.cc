#include <stdio.h>
#include <ctype.h>
#include <iostream.h>
#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include <Inventor/Xt/viewers/SoXtExaminerViewer.h>
#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/SbLinear.h>
#include <Inventor/fields/SoMFVec3f.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoRotation.h>
#include <Inventor/nodes/SoRotationXYZ.h>
#include <Inventor/nodes/SoTranslation.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/Xt/SoXtRenderArea.h>
#include <Inventor/nodes/SoText2.h>
#include <Inventor/nodes/SoFont.h>
#include <Xm/SelectioB.h>
#include "ivButton.hh"
#include "mcfEnergyScaleWindow.hh"
#include "mcfDisplayList.hh"
#include "misc.h"
extern "C" {
#include "DialogF.h"
}

//storage for static variable
mcfEnergyScaleWindow *mcfEnergyScaleWindow::_energyScaleWindow = NULL;
enum plotEnergyScaleMenuEntries {
    ES_FILE,
    ES_FILE_DISMISS,
    
    ES_MODIFY,
    ES_MODIFY_CHANGEMAX,

    ES_HELP,
    ES_HELP_OVERALL,

    ES_MENU_NUM		// this must be the last entry
};

//
mcfEnergyScaleWindow *mcfEnergyScaleWindow::energyScaleWindow(Widget parent)
{
    if(_energyScaleWindow == NULL)
    _energyScaleWindow = new mcfEnergyScaleWindow(parent);
    
    if(_energyScaleWindow->GetPopped() == 0)
    {
       XtRealizeWidget(_energyScaleWindow->Shell);
    }

    
    return _energyScaleWindow;
}


void mcfEnergyScaleWindow::makeMcfWindow(Widget main)
{

// define the buttons and the pulldowns
static ivButton buttonData[] = {
   {"Dismiss...", ES_FILE_DISMISS,  IV_PUSH_BUTTON, "", ""},
   {"Change Max...", ES_MODIFY_CHANGEMAX,  IV_PUSH_BUTTON, "", ""},
   {"About...", ES_HELP_OVERALL,  IV_PUSH_BUTTON, "", ""}
};
static ivMenu pulldownData[] = {
// {name, id, subMenu, subItemCount}
   {"File",  ES_FILE, buttonData, 1 },
   {"Modify",  ES_MODIFY, buttonData+1, 1 },
   {"Help",  ES_HELP, buttonData+2, 1 }
};
// Now do the work
   Shell = MakeDetachedShell( main, "Calorimeter Energy Scale");
   form = MakeForm(Shell, 550, 250);


   Widget menuWidget = buildAndLayoutMenu(form, pulldownData,
                                                XtNumber( pulldownData ),
                                                (XtCallbackProc) 
                                                          energyScaleMenuCB);
   SoXtRenderArea *component = buildAndLayoutViewer(
                             form, menuWidget, RENDER);
   component->setSceneGraph(makeScale());
   component->setTitle("Calorimeter Energy Scale");
   component->show();
   XtManageChild(form);
   XtRealizeWidget(Shell); 
   return;
      
   
}
SoSeparator *mcfEnergyScaleWindow::makeScale(void)
{
   int npoints = 2;
   int i;
   char string[132];
   SoFont *font = new SoFont;
   font->name.setValue("Times-Roman");
   font->size.setValue(18.0);

   SoSeparator *scalePrim = new SoSeparator;
   SoSeparator *scale = new SoSeparator;
   scale->ref();
   scale->addChild(font);
   SoCoordinate3 *scaleCoords = new SoCoordinate3;
   SoLineSet *scaleLine = new SoLineSet;

   SbVec3f *scalePoints = new SbVec3f[2];
   (scalePoints)->setValue(-.5,-.50,0.);
   (scalePoints+1)->setValue(-.5,.50,0.0);
   scaleCoords -> point.setValues(0,npoints,scalePoints);
   scaleLine -> numVertices.setValues(0,1,&npoints);

   SoTranslation *scaleTranslation = new SoTranslation;
   scaleTranslation->translation.setValue(0.001,0.0,0.0);

   scalePrim->addChild(scaleCoords);
   scalePrim->addChild(scaleLine);
   for (i = 0; i<1000; i++)
   {
	SoMaterial *material = new SoMaterial;
	material ->diffuseColor.setHSVValue(1. - i/1000., i/1000., 1.);
	scale->addChild(scaleTranslation);
	scale->addChild(material);
	scale->addChild(scalePrim);
   }
   SoTranslation *textTranslation = new SoTranslation;
   textTranslation->translation.setValue(-0.5,-0.7,0.0);
   sprintf(string,"%f GeV", maxScale);
   SoText2 *text = new SoText2;
   text->justification = SoText2::CENTER;
   text->string.setValue(string);
   text->setName("MaxScale");
   scale->addChild(textTranslation);
   scale->addChild(text);
   scale->setName("CalEnergyScale");
   return scale;

}

void mcfEnergyScaleWindow::updateMax(float max)
{
   char string[132];
   maxScale = max;
   SoSeparator *tempScale;
   tempScale = (SoSeparator *)SoNode::getByName("CalEnergyScale");
   SoText2 *tempText;
   tempText = (SoText2 *)SoNode::getByName("MaxScale");
   sprintf(string,"%f5 GeV", maxScale);
   SoText2 *newText = new SoText2;
   newText->justification = SoText2::CENTER;
   newText->string.setValue(string);
   newText->setName("MaxScale");
   tempScale->replaceChild(tempText,newText);

}

static void energyScaleMenuCB( Widget, XtPointer *data, XtPointer *)
{
    ivMenuItem *menudata = (ivMenuItem *) data;
    mcfEnergyScaleWindow *win = (mcfEnergyScaleWindow *)menudata->mcfWin;
     
    switch (menudata->id) {


    case ES_FILE_DISMISS:
       win->SetPopped(0);
       XtUnrealizeWidget(win->Shell);
       break;
    case ES_MODIFY_CHANGEMAX:
      //prompt dialog
      if(win->prompt == NULL)
      {
         XmString label = XmStringCreateLocalized
            ("Enter Saturation Value in GeV:");
         int n = 0;
         Arg args[20];
         XtSetArg (args[n], XmNselectionLabelString, label); n++;
         XtSetArg (args[n], XmNautoUnmanage, False); n++;
         
         win->prompt = XmCreatePromptDialog(XtParent(win->form), 
                 "Max Scale", args, n);
         XtAddCallback(win->prompt, XmNokCallback, 
                      (XtCallbackProc) newScaleValueCB, (XtPointer *) win);
         XtAddCallback(win->prompt, XmNcancelCallback, 
                      (XtCallbackProc) noScaleValueCB, (XtPointer *) win);
         XtSetSensitive(
               XmSelectionBoxGetChild (win->prompt,
                              XmDIALOG_HELP_BUTTON),False);
         XmStringFree(label);
      }
       
      XtManageChild(win->prompt);
      XtPopup(XtParent(win->prompt), XtGrabNone);
      break;
    case ES_HELP_OVERALL:
      DialogF(DF_INF, XtParent(win->getForm()), 1,
      "This panel displays the energy scale for hit calorimeter cells.",
	    "OK"); 
       break;

    }
    
}

static void newScaleValueCB(Widget, XtPointer *data, XtPointer *call)
{
    mcfEnergyScaleWindow *win = (mcfEnergyScaleWindow *) data;
    XmSelectionBoxCallbackStruct *cbs = (XmSelectionBoxCallbackStruct *)call;
    char *text;
    float max = 0;
    if(XmStringGetLtoR (cbs->value, "", &text) )
    {
       sscanf(text, "%f", &max);
       win->updateMax(max);
       XtFree(text);
       mcfDisplayList *list = mcfDisplayList::mcfDispGetHead();
       list->mcfDisplayUpdateAllCal();
    }
    XtUnmanageChild(win->prompt);
    XtPopdown(XtParent(win->prompt));
    return;
}
static void noScaleValueCB(Widget, XtPointer *data, XtPointer *call)
{
    mcfEnergyScaleWindow *win = (mcfEnergyScaleWindow *) data;
    XtUnmanageChild(win->prompt);
    XtPopdown(XtParent(win->prompt));
    return;
}
