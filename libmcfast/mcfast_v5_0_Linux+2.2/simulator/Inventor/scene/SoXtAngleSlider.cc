/********************************************************************/
/*     SoXtAngleSlider.C                                            */
/*                                                                  */
/*     This class makes two sliders for interactive control of      */
/*     the angles used to make conical and tubular sections.        */
/*     This allows for interactive cutaway views.                   */
/*                                                                  */
/*     Written January 13, 1997   Amber Boehnlein, FNAL CD          */
/********************************************************************/
#include <X11/StringDefs.h>
#include <X11/Intrinsic.h>
#include <X11/Xatom.h>

#include <Xm/Xm.h>
#include <Xm/RowColumn.h>
#include <Xm/Form.h>
#include <Xm/Label.h>
#include <Xm/Scale.h>

#include <Inventor/Xt/SoXt.h>
#include <Inventor/fields/SoSFFloat.h>
#include "hepvis/SoXtAngleSlider.hh"
#include "hepvis/SoG4Cons.hh"

//set default for the number of decimal places on scale

const float SCALE = 100.;

SoXtAngleSlider::SoXtAngleSlider(
         Widget parent,
         const char *name,
         SbBool BuildInsideParent) :
         SoXtComponent(parent, name, BuildInsideParent)
         {
             cons = NULL;
             
             Widget w = buildWidget(parent);
             setBaseWidget(w);
         } 
         
SoXtAngleSlider::~SoXtAngleSlider()
{
    //damned if I know.  Do I need to delete widgets?
}
void SoXtAngleSlider::attachSliders(SoG4Cons *c)
{
   int n = 0;
   
   Arg args[1];
   
   if(c != NULL)
   {
   
       cons = c;
       
       if ( cons->fSPhi.getValue() < 0.0 ) cons->fSPhi.setValue( 0.0 );
       if ( cons->fDPhi.getValue() < 0.0 ) cons->fDPhi.setValue( 0.0 );
       
       if ( cons->fSPhi.getValue() > 2*M_PI ) cons->fSPhi.setValue( 2*M_PI );
       if ( cons->fDPhi.getValue() > 2*M_PI ) cons->fDPhi.setValue( 2*M_PI );
       

       XtSetArg( args[n], XmNvalue, (int) (cons->fSPhi.getValue()*SCALE) ); n++;
       XtSetValues( SPhiSlider, args, n );
       
       n = 0;
       XtSetArg( args[n], XmNvalue, (int) (cons->fDPhi.getValue()*SCALE) ); n++;
       XtSetValues( FPhiSlider, args, n );
       
   }
   return;

   
}

Widget SoXtAngleSlider::buildWidget(Widget parent)
{
   Arg args[10];
   int n;
   
   //Create a form widget to hold the stuff
   Widget shell = XtVaAppCreateShell ("Inventor", "Inventor",
	         topLevelShellWidgetClass, SoXt::getDisplay(),
	         XmNtitle, "slideShell",
	         XmNiconName, "slideShell",
	         XmNallowShellResize, False, 0);
   Widget form = XtCreateWidget(getWidgetName(),
                                xmFormWidgetClass,
                                shell, NULL, 0);
   //register the form
   registerWidget(shell);
   
   //provide a label
   XmString str = XmStringCreate("Modify Angles", 
                         XmSTRING_DEFAULT_CHARSET);
   n = 0;
   XtSetArg(args[n], XmNtopAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNtopOffset,   8); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNrightAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNleftOffset,   0); n++;
   XtSetArg(args[n], XmNlabelString, str); n++;


   Widget label = XmCreateLabel(form, "Label", args, n);
   XtManageChild(label);
   XmStringFree(str);
   
   //rowcolumn Widget to hold the sliders

   Widget rowCol = XtVaCreateWidget(getWidgetName(),
                     xmRowColumnWidgetClass, form,
                     XmNorientation, XmHORIZONTAL,
                     XmNpacking, XmPACK_COLUMN,
                     XmNnumColumns, 2, //#of columns
                     NULL);
   
   n = 0;
   XtSetArg(args[n], XmNtopAttachment,    XmATTACH_WIDGET); n++;
   XtSetArg(args[n], XmNtopWidget,        label); n++;
   XtSetArg(args[n], XmNtopOffset,   10); n++;
   XtSetArg(args[n], XmNleftAttachment,  XmATTACH_FORM); n++;
   XtSetArg(args[n], XmNleftOffset,   10); n++;
   XtSetValues(rowCol, args, n);

   SPhiSlider = XtVaCreateManagedWidget("StartAngle",
                      xmScaleWidgetClass, rowCol,
                      XtVaTypedArg, 
                      XmNtitleString, XmRString, 
                      "Start Angle", 12, 
                      XmNmaximum, (int) (2*M_PI*SCALE),
                      XmNminimum, 000,
                      XmNdecimalPoints, 2,
                      XmNvalue, 0,
                      XmNorientation, XmHORIZONTAL,
                      XmNprocessingDirection, XmMAX_ON_RIGHT,
                      XmNshowValue, True, NULL);
                      
   
   XtAddCallback(SPhiSlider, XmNvalueChangedCallback,
                (XtCallbackProc) SoXtAngleSlider::angleCB,
                ( XtPointer *) this);
   
   FPhiSlider = XtVaCreateManagedWidget("FinishAngle",
		    xmScaleWidgetClass, rowCol,
		    XtVaTypedArg, 
                    XmNtitleString, XmRString, 
                    "Delta Angle", 12, 
		    XmNmaximum, (int) (2*M_PI*SCALE),
		    XmNminimum, 0,
		    XmNdecimalPoints, 2,
		    XmNvalue, (int) (2*M_PI*SCALE),
		    XmNorientation, XmHORIZONTAL,
		    XmNprocessingDirection, XmMAX_ON_RIGHT,
		    XmNshowValue, True, NULL);
		      
 
   XtAddCallback(FPhiSlider, XmNvalueChangedCallback,
	      (XtCallbackProc) SoXtAngleSlider::angleCB,
	      ( XtPointer *) this);
                
   XtManageChild(rowCol);
   XtManageChild(form);
   return shell;
}
void SoXtAngleSlider::angleCB(Widget, XtPointer userData, XtPointer )
{
   int value;
   SoXtAngleSlider *angleSlider = (SoXtAngleSlider *) userData;
   if( angleSlider->isAttached() )
   {
       XmScaleGetValue(angleSlider->SPhiSlider, &value);
       angleSlider->cons->fSPhi.setValue( (float) ( value/SCALE ) );
       
       XmScaleGetValue(angleSlider->FPhiSlider, &value);
       angleSlider->cons->fDPhi.setValue( (float) ( value/SCALE ) );

   }
   return;
   
   
} 
