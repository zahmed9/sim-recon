#include <string.h>
#include "McFDetectorTreeList.hh"
#include "mcfWindow.hh"
#include "mcfDetectorModifyWindow.hh"
#include <Inventor/fields/SoSFString.h>
#include <Inventor/Xt/SoXtMaterialEditor.h>
#include <Inventor/Xt/SoXt.h>
#include <Xm/PushB.h>
#include "mcfPickInfoWindow.hh"
#include "detectorPrint.hh"

extern "C" {
#include "tree.h"
}
struct controlblock
{
   Widget w;
   McFDetectorTreeList *pNode;
};

McFDetectorTreeList *McFDetectorTreeList::pHead = NULL;
listSelPolicy McFDetectorTreeList::selectionPolicy = CHILDREN;
void McFDetectorTreeList::detectorAddToList( McFDetectorTreeList *temp )
{
   static McFDetectorTreeList *last;
   if( pHead == NULL )
   {
      pHead = temp;
      last = temp;
      return;
   }
   else
   {
      last->pNextDetector = temp;
   }
   last = temp;
   return;
}
void McFDetectorTreeList::AddToTopOfTree( void )
{
//this method adds sisters at the top level of the tree
   McFDetectorTreeList *ptemp, *ptemp2;
   ptemp = this;

   if(pHead->pdaughterDetector == NULL) //first detector
   {
      pHead->pdaughterDetector = ptemp;
   }
   else
   {  
      ptemp2 = pHead->pdaughterDetector;
      while( ptemp2->psisterDetector != NULL)
      {
         ptemp2 = ptemp2->psisterDetector;
      }
      ptemp2->psisterDetector = ptemp;
   }
   return;

}
void McFDetectorTreeList::AddLeaf(McFDetectorTreeList *pmother) 
{
   McFDetectorTreeList *ptemp, *ptemp2;
   ptemp = this;
   if(pmother->pdaughterDetector == NULL)
   {
      pmother->pdaughterDetector = ptemp;
   }
   else
   { 
      ptemp2 = pmother->pdaughterDetector;
      while( ptemp2->psisterDetector != NULL)
      {
         ptemp2 = ptemp2->psisterDetector;
      }
      ptemp2->psisterDetector = ptemp;
   }
   ptemp->pmotherDetector = pmother;   
   return;
}
void McFDetectorTreeList::FreeList( void )
{
    McFDetectorTreeList *temp, *temp2;
    temp = pHead;
    while( temp != NULL)
    {
      temp2 = temp->pNextDetector;
      delete temp;
      temp = temp2;
    }
    pHead = NULL;
    return;
}
McFDetectorTreeList *McFDetectorTreeList::findDetectorByName(char *name)
{
   McFDetectorTreeList *temp;
   temp = pHead;
   while( temp != NULL)
   {
      if(strcmp(temp->detector.name,name) == 0) return temp;
      temp = temp->pNextDetector;
   }
   return NULL;
   
}
McFDetectorTreeList *McFDetectorTreeList::findDetectorByType(int32_t type)
{
   McFDetectorTreeList *temp;
   int32_t id;
   temp = pHead;
   while( temp != NULL)
   {
      id = temp->detector.deviceId;
      if(type == id) return temp;
      temp = temp->pNextDetector;
   }
   return NULL;
   
}
char **McFDetectorTreeList::makeListOfNames(void)
{
   McFDetectorTreeList *temp;
   int nDetectors = 0;
   char *names[50];
   temp = pHead;
   while(temp != NULL)
   {
      nDetectors++;
      temp=temp->pNextDetector;
   }
   *names = new char[nDetectors];
   int i = 0;
   while(temp != NULL)
   {
      strcpy(names[i], temp->detector.name);
      temp=temp->pNextDetector;
   }
   return names;   
}
void McFDetectorTreeList::MakeTree(Widget parent)
{
     pHead->AddButtonsToTree(NULL, parent);
}
void McFDetectorTreeList::AddButtonsToTree(Widget parent, Widget treeWidget)
{
//I used Drew Baden's ztree.c and cbranch.c (D0$xframe$source) as references
//for this code
     McFDetectorTreeList *pNode = this;
     int n = 0;
     Arg args[10];
     Widget daughter;

    //Use a fixed character font to make text on the buttons smaller
    XFontStruct *xfont = XLoadQueryFont(SoXt::getDisplay(),
            "-misc-fixed-medium-r-normal-*-13-120-75-75-c-70-iso8859-1");

    
    XtSetArg(args[n],XmNfontList, XmFontListCreate(xfont, "charset")); n++;

    //make a little border around the words
    XtSetArg(args[n], XmNborderWidth, 2); n++;
    
    //make button 
    XtSetArg(args[n], XtNsuperNode, parent); n++;
    

    //get the name to put on the node
    XmString str = XmStringCreateSimple(pNode->detector.name);
    XtSetArg(args[n], XmNlabelString, str); n++;
    XtSetArg(args[n], XmNshadowThickness, 0); n++;
    
    daughter = XtCreateManagedWidget(pNode->detector.name,
                      xmPushButtonWidgetClass, treeWidget, args, n);

    XmStringFree(str);
    XtAddCallback(daughter, XmNactivateCallback, 
        (XtCallbackProc) McFDetectorTreeList::buttonCallback, 
    	(XtPointer *) this);
	

   //memory leak!
    controlblock *ctrlBlock = new controlblock;
    ctrlBlock->pNode = this;
    XtAddEventHandler(daughter, EnterWindowMask, FALSE, 
               (XtEventHandler) McFDetectorTreeList::FocusLabelSet,
	       (char* ) ctrlBlock);
    XtAddEventHandler(daughter, LeaveWindowMask, FALSE, 
               (XtEventHandler) McFDetectorTreeList::FocusLabelSet,
	       (char* ) ctrlBlock);
     XtAddEventHandler(daughter, ButtonPressMask, FALSE, 
               (XtEventHandler) McFDetectorTreeList::RightButton,
	       (char* ) ctrlBlock);
        
    pNode->button = daughter;
                 
    if(pNode->isSelected)
    {
    //for selected buttons, switch foreground and background 
    //colors
    
	Pixel foreground;
	Pixel background;
	XtVaGetValues(daughter, 
                      XmNforeground, &foreground,
                      XmNbackground, &background, NULL);
	XtVaSetValues(daughter, 
                      XmNforeground, background,
                      XmNbackground, foreground, NULL);
    }
    if(pNode->isContracted) return;


    //now loop over the daughters
    pNode = pNode->pdaughterDetector;
    
    //here, add checking code for the depth of the tree.
    //start out displaying the whole thing.
    
    while( pNode != NULL)
    {
        pNode->AddButtonsToTree(daughter, treeWidget);
        pNode = pNode->psisterDetector;
    }
    return;

}

void McFDetectorTreeList::setSelected(Boolean selected)
{
    McFDetectorTreeList *pNode = this;
    
    if(pNode->button != NULL && (selected != pNode->isSelected))
    {
 	Widget daughter = pNode->button;

	//for selected buttons, switch foreground and background 
	//colors

	Pixel foreground;
	Pixel background;
	XtVaGetValues(daughter, 
                      XmNforeground, &foreground,
                      XmNbackground, &background, NULL);
	XtVaSetValues(daughter, 
                      XmNforeground, background,
                      XmNbackground, foreground, NULL);
    }
                 
    if(selected != pNode->isSelected) pNode->isSelected = selected;
    if(selectionPolicy == SELF) return;

    //loop over children if requested:
    if(selectionPolicy == CHILDREN || selectionPolicy == DESELECT)
    {
	pNode = pNode->pdaughterDetector;


	while( pNode != NULL)
	{
            pNode->setSelected(selected);
            pNode = pNode->psisterDetector;
	}
    }
    else if(selectionPolicy == SISTERS)
    {
	pNode = pNode->psisterDetector;


	while( pNode != NULL)
	{
            pNode->setSelected(selected);
            pNode = pNode->psisterDetector;
	}
    }
       
    return;

}
void McFDetectorTreeList::setNoWidget(void)
{
      McFDetectorTreeList *pNode = this;
      pNode->button = NULL;


      pNode = pNode->pdaughterDetector;
      while (pNode != NULL)
      {
          pNode->setNoWidget();
          pNode = pNode->psisterDetector;
          
      }
  
}
void McFDetectorTreeList::setContracted(void)
{
    McFDetectorTreeList *pNode = this;
    
    
    if(pNode->isContracted == TRUE)
    {
       pNode->isContracted = FALSE;
       
    }
    else
    {
       pNode->isContracted = TRUE;
       pNode = pNode->pdaughterDetector;
       
      while (pNode != NULL)
      {
          //make sure that no old widgets
          // are left hanging after the tree
          // is remade
          pNode->setNoWidget();
          pNode = pNode->psisterDetector;
          
      }
       
    }

     return;

}
void McFDetectorTreeList::setMaterial(const SoMaterial *material)
{
    McFDetectorTreeList *pNode = this;
    
   
    
    if(pNode->isSelected == TRUE)
    {
       SoMaterial *theMaterial = (SoMaterial *)
                    detectorKit->getPart("appearance.material",TRUE);
       
       if(theMaterial != NULL)
       {
          theMaterial->copyFieldValues(material);
       }
       
       
    }
    pNode = pNode->pdaughterDetector;
       
    while (pNode != NULL)
    {
          pNode->setMaterial(material);
          pNode = pNode->psisterDetector;
          
    }
       
     return;

}
void McFDetectorTreeList::setRep(int setting)
{
    McFDetectorTreeList *pNode = this;
    
    
    if(pNode->isSelected == TRUE)
    {
      if(setting == 0)
      {
        detectorKit->setPreview(FALSE);
      }
      else if(setting == 1)
      {
        detectorKit->setPreview(TRUE);
      }
      else if(setting == 2)
      {
        detectorKit->setOff();
      }
       
    }
    pNode = pNode->pdaughterDetector;
       
    while (pNode != NULL)
    {
          pNode->setRep(setting);
          pNode = pNode->psisterDetector;
          
    }
       
     return;

}
void McFDetectorTreeList::setStyle(int setting)
{
    McFDetectorTreeList *pNode = this;
    
    
    if(pNode->isSelected == TRUE)
    {
        SoDrawStyle *drawStyle = (SoDrawStyle *)
                detectorKit->getPart("appearance.drawStyle",TRUE);
        if(drawStyle != NULL)
        {
           if(setting == 0)
           {
             drawStyle->style = SoDrawStyle::FILLED;
           }
           else if(setting == 1)
           {
             drawStyle->style = SoDrawStyle::LINES;
           }
           else if(setting == 2)
           {
             drawStyle->style = SoDrawStyle::INVISIBLE;
           }
        }
       
    }
    pNode = pNode->pdaughterDetector;
       
    while (pNode != NULL)
    {
          pNode->setStyle(setting);
          pNode = pNode->psisterDetector;
          
    }
       
     return;

}
McFDetectorTreeList *pNodeClick = NULL;
void McFDetectorTreeList::buttonCallback(
                        Widget, XtPointer *data, XtPointer *callData)
{
    const int interval = 1000;
    static XtIntervalId timer;
    pNodeClick = (McFDetectorTreeList *) data;
    XmPushButtonCallbackStruct *reason = (XmPushButtonCallbackStruct *)
                                          callData; 
    if (reason->click_count == 1 ) {
	    timer = XtAppAddTimeOut(SoXt::getAppContext(),
	                         interval, 
	                         McFDetectorTreeList::buttonProcess,0);
    }
    else if (reason->click_count == 2) {
	    XtRemoveTimeOut(timer);
	    McFDetectorTreeList::buttonProcess((XtPointer) 1, &timer);
    }
                                           
}
void McFDetectorTreeList::buttonProcess(XtPointer data, XtIntervalId *)
//after 
{
      int doubleClick = (int ) data;
      if(doubleClick) //double click, expand or contract tree
      {
         pNodeClick->setContracted();
         mcfDetectorModifyWindow::remakeTree();
      }
      else
      {
	 if(pNodeClick->isSelected == TRUE)
	 {
	    pNodeClick->setSelected(FALSE);
	 }
	 else
	 {
	    pNodeClick->setSelected(TRUE);
	 }
      }
      
}
void McFDetectorTreeList::DeselectAll(Widget, XtPointer, XtPointer)
{
  listSelPolicy oldPolicy = selectionPolicy;
  selectionPolicy = DESELECT;
  pHead->setSelected(FALSE);
  selectionPolicy = oldPolicy;
      
}
void McFDetectorTreeList::VisibilityModifyCB(Widget, XtPointer *data, 
                                           XtPointer *callData)
{
   XmToggleButtonCallbackStruct *state = 
          ( XmToggleButtonCallbackStruct *) callData;
   return;
}
void McFDetectorTreeList::StyleModifyCB(Widget, XtPointer *data, XtPointer *callData)
{
   XmToggleButtonCallbackStruct *state = 
          ( XmToggleButtonCallbackStruct *) callData;
   toggleButtonCbData *cldata = (toggleButtonCbData *) data;
   if(state->set)
   {
     int setting = cldata->setting;
     pHead->setStyle(setting);
   }
   return;
}
void McFDetectorTreeList::RepModifyCB(Widget, XtPointer *data,
                                    XtPointer *callData)
{
   XmToggleButtonCallbackStruct *state = 
          ( XmToggleButtonCallbackStruct *) callData;
   toggleButtonCbData *cldata = (toggleButtonCbData *) data;
    
   if(state->set)
   {
      int setting = cldata->setting;
      pHead->setRep(setting);
   }
   return;
}

void McFDetectorTreeList::MaterialEditorCB(void *, const SoMaterial *matl)
{
  
  pHead->setMaterial(matl);
  return;

}
void McFDetectorTreeList::CutCylindersCB(Widget, XtPointer *data, 
                                       XtPointer *callData)
{
    return;
}
void McFDetectorTreeList::selectPolicyCB(Widget, XtPointer *data, 
                       XtPointer *callData)
{ 
   XmToggleButtonCallbackStruct *state = 
          ( XmToggleButtonCallbackStruct *) callData;
   toggleButtonCbData *cldata = (toggleButtonCbData *) data;
    
   if(state->set)
   {
      selectionPolicy = (listSelPolicy) cldata->setting;
   }
   return;
}
void McFDetectorTreeList::FocusLabelSet(Widget w, controlblock *ctrlBlk, 
       XEvent *event, Boolean *continueToDispatch)	     
{
       *continueToDispatch=TRUE;
       int n = 0;
       Arg args[10];
       char text[1000];
       McFDetectorTreeList *pNode = ctrlBlk->pNode;
       if(event->type == EnterNotify)
       {
         strcpy(text,pNode->detector.name);
	 strcat(text, ": ");
         SoMcFDetectorTreeKit *kit = (SoMcFDetectorTreeKit *)
	                                       ctrlBlk->pNode->detectorKit;
         SoDrawStyle *drawStyle = (SoDrawStyle *)
                kit->getPart("appearance.drawStyle",TRUE);
         if(drawStyle->style.getValue() == SoDrawStyle::FILLED)
         {
	    strcat(text, "Solid, ");
	 }  
         else if(drawStyle->style.getValue() == SoDrawStyle::LINES)
         {
	    strcat(text, "Wireframe, ");
         }
         else if(drawStyle->style.getValue() == SoDrawStyle::INVISIBLE)
         {
	    strcat(text, "Invisible, ");
         }
	 if(kit->isVisible()==FALSE)
	 {
	    strcat(text, "Not Shown");
	 }
	 else if(kit->getPreview() == TRUE)
	 {
	    strcat(text, "Less Detail");
	 }
	 else if(kit->getPreview() == FALSE)
	 {
	    strcat(text, "More Detail");
	 }

	 
         XmString str = XmStringCreateSimple(text);
         XtSetArg(args[n], XmNlabelString, str); n++;
         XtSetValues(w, args, n);
         XmStringFree(str);
       }
       if(event->type == LeaveNotify)
       {
         XmString str = XmStringCreateSimple(pNode->detector.name);
         XtSetArg(args[n], XmNlabelString, str); n++;
         XtSetValues(w, args, n);
         XmStringFree(str);
       }
       return;

} 
void McFDetectorTreeList::RightButton(Widget w, controlblock *ctrlBlk, 
       XButtonEvent *event, Boolean *continueToDispatch)
{
        *continueToDispatch=TRUE;
        if(event->button == Button3)
	{
	     mcfPickInfoWindow *pickWindow = 
                mcfPickInfoWindow::pickInfoWindow(SoXt::getTopLevelWidget());
             McFDetectorTreeList *pNode = ctrlBlk->pNode;
             SoMcFDetectorTreeKit *This = (SoMcFDetectorTreeKit *)
	                                       ctrlBlk->pNode->detectorKit;
	     pickWindow->updateText(printDetector
	      ( This->device, This->whichDevice));
        }
        return;
        	     
}
