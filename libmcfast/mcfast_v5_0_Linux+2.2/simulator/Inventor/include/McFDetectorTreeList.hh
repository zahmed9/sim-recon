#ifndef MCFDETECTORTREELIST
#define MCFDETECTORTREELIST
#include "hepvis/SoMcFDetectorTreeKit.hh"
#include <Inventor/SbBasic.h>
#include "McFDetector.hh"

#include <X11/StringDefs.h>
#include <X11/Intrinsic.h>
#include <X11/Xatom.h>

#include <Xm/Xm.h>

struct controlblock;
class McFDetector;
class SoMaterial;
enum listSelPolicy 
{
  CHILDREN = 0, SISTERS, SELF, DESELECT
};
//this list is organized for traversal in two ways, one as a flat list,
//the other as a tree of detectors

//probably in an ideal world, I would make all the links in the constructor
//I have chosen only to make the flat list link in the constructor and fill
//the mothers, daughters and sisters separately.
class McFDetectorTreeList
{
   private:
       McFDetectorTreeList *pNextDetector;
       McFDetectorTreeList *pmotherDetector;
       McFDetectorTreeList *psisterDetector;
       McFDetectorTreeList *pdaughterDetector;
       static McFDetectorTreeList *pHead; 
       static listSelPolicy selectionPolicy;
       SoMcFDetectorTreeKit *detectorKit; //contains Inventor information
       Boolean isContracted;
       Boolean isSelected;
       Widget button;       
       
       void detectorAddToList( McFDetectorTreeList *temp );
   public:
       McFDetector detector;  //contains Identifier Information for McFast
                              //this is public to avoid needless get/set 
                              //routines
       McFDetectorTreeList(void)
       {
          pNextDetector = NULL;
          pmotherDetector = NULL;
          psisterDetector = NULL;
          pdaughterDetector = NULL;
          detectorKit = new SoMcFDetectorTreeKit();
          detectorAddToList( this );
          isContracted = FALSE;
          isSelected = FALSE;
          button = NULL;
       }
       ~McFDetectorTreeList(void)
       {
          //the inventor stuff will free itself when the 
          //geometry is deleted
       }
       void FreeList(void);
       McFDetectorTreeList *findDetectorByName(char *name);
       McFDetectorTreeList *findDetectorByType(int32_t type);
       char **makeListOfNames(void);
       void AddToTopOfTree( void );
       void AddLeaf(McFDetectorTreeList *pmother); 
       SoMcFDetectorTreeKit *getDetectorKit(void)
       {
           return detectorKit;
       }
       void doContracted(Boolean contract)
       {
           isContracted = contract;
       }
 
//for making the tree of widgets
       static void MakeTree(Widget parent);               
       void AddButtonsToTree(Widget parent, Widget treeWidget);


       

//for processing the callbacks
       static void  buttonCallback(Widget, XtPointer *data, XtPointer
       *callData);
       static void buttonProcess(XtPointer data, XtIntervalId *);
       static void VisibilityModifyCB(Widget, XtPointer *data, XtPointer
       *callData);
       static void StyleModifyCB(Widget, XtPointer *data, XtPointer
       *callData);
       static void RepModifyCB(Widget, XtPointer *data, XtPointer
       *callData);
       static void MaterialEditorCB(void *, const SoMaterial *matl);
       static void CutCylindersCB(Widget, XtPointer *data, XtPointer 
       *callData);
       static void DeselectAll(Widget, XtPointer, XtPointer);              
       static void selectPolicyCB(Widget, XtPointer *data, 
                       XtPointer *callData);
       static void FocusLabelSet(Widget w, controlblock *ctrlBlk, 
       XEvent *event, Boolean *continueToDispatch);	     
       static void RightButton(Widget w, controlblock *ctrlBlk, 
       XButtonEvent *event, Boolean *continueToDispatch);// for changing the settings on the callbacks
       void setSelected(Boolean selected);
       void setContracted(void);
       void setNoWidget(void);
       void setMaterial(const SoMaterial *material);
       void setRep(int setting);
       void setStyle(int setting);
       

};
#endif
